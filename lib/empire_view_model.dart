import 'dart:async';

import 'package:flutter/foundation.dart';

import 'empire_property.dart';

///A ViewModel is an abstraction of the view it is bound to and represents the current state of
///the data in your model.
///
///This is where any logic that manipulates your model should be. An [EmpireWidget] and it's
///accompanying state always has access to it's view model via the viewModel property.
///
///Update events are automatically emitted whenever the value of an [EmpireProperty] is changed.
///The [EmpireState] the ViewModel is bound to will update itself each time an [EmpireProperty] value
///is changed and call the states build function, updating the UI.
abstract class EmpireViewModel {
  final StreamController<List<EmpireStateChanged>> _stateController = StreamController.broadcast();
  final StreamController<ErrorEvent> _errorController = StreamController.broadcast();
  late final Stream<List<EmpireStateChanged>> _stream;
  late final Stream<ErrorEvent> _errorStream;

  final List<StreamSubscription> _subscriptions = [];

  bool _busy = false;
  bool get busy => _busy;

  final List<dynamic> _busyTaskKeys = [];
  List<dynamic> get activeTasks => _busyTaskKeys;

  EmpireViewModel() {
    _stream = _stateController.stream;
    _errorStream = _errorController.stream;
    initProperties();
  }

  ///Initializes all [EmpireProperty] properties in the ViewModel.
  ///
  ///This method is automatically called
  ///during object construction and should not be called manually.
  ///
  ///All [EmpireProperty] properties must be defined with the `late final` keywords. For example:
  ///```dart
  ///late final EmpireProperty<int> age;
  ///```
  ///When overriding the initProperties functions you would initialize your [EmpireProperty] like so:
  ///```dart
  ///@override
  ///void initProperties() {
  ///    age = EmpireProperty<int>(0, this);
  ///}
  ///```
  ///You can also initialize properties using the [createProperty] function:
  ///```dart
  ///@override
  ///void initProperties() {
  ///    age = createProperty(0);
  ///}
  ///```
  void initProperties();

  ///Adds an event handler which gets executed each time an [EmpireProperty] value is changed.
  void addOnStateChangedListener(Function(List<EmpireStateChanged>) onStateChanged) {
    _subscriptions.add(_stream.listen(onStateChanged));
  }

  ///Adds an event handler which gets executed each time [notifyError] is called.
  void addOnErrorEventListener(Function(ErrorEvent) onError) {
    _subscriptions.add(_errorStream.listen(onError));
  }

  ///Inform the bound [EmpireState] that the state of the UI needs to be updated.
  ///
  ///**NOTE**: Although you CAN call this method manually, it's usually not required. Updating the
  ///value of an [EmpireProperty] will automatically notify the UI to update itself.
  void notifyChanges(List<EmpireStateChanged> events) {
    _stateController.add(events);
  }

  ///Set multiple [EmpireProperty] values, but only trigger a single state change
  ///
  ///The [setters] keys should be the properties you want to set. The values should be the new
  ///values for each property.
  ///
  ///## Usage
  ///
  ///```dart
  ///late final EmpireProperty<String> name;
  ///late final EmpireProperty<int> age;
  ///
  ///setMultiple({name: 'Doug', age: 45});
  ///```
  void setMultiple(Map<EmpireProperty, dynamic> setters) {
    final List<EmpireStateChanged> changes = [];
    for (var property in setters.keys) {
      final previousValue = property.value;
      final nextValue = setters[property];

      changes.add(EmpireStateChanged(nextValue, previousValue, propertyName: property.propertyName));

      property(nextValue, notifyChange: false);
    }
    notifyChanges(changes);
  }

  ///Inform the bound [EmpireState] that an error has occurred.
  ///
  ///Any event handlers registered by the
  ///[addOnErrorEventListener] function will be executed
  void notifyError(ErrorEvent event) => _errorController.add(event);

  ///Explicitly updates the current busy status of the view model.
  ///
  ///Can use this in conjunction with the [EmpireState.ifBusy] function on the [EmpireState] to show
  ///a loading indicator when performing a long running task. Can also determine the current busy
  ///status by accessing the [busy] property on the view model.
  ///
  ///See [doAsync] for [busyTaskKey] usage.
  ///
  ///Updating the busy status is automatic when using the [doAsync] function.
  void setBusyStatus({required bool isBusy, dynamic busyTaskKey}) {
    if (_busy != isBusy) {
      if (isBusy) {
        _addBusyTaskKey(busyTaskKey);
      } else {
        _removeBusyTaskKey(busyTaskKey);
      }
      _busy = isBusy;
      notifyChanges([EmpireStateChanged(isBusy, !isBusy)]);
    }
  }

  ///Executes a long running task asynchronously.
  ///
  ///Automatically sets the view model [busy] status.
  ///
  ///[busyTaskKey] can be optionally set to help identify why the view model is busy. This can then
  ///be accessed by the UI to react differently depending on what the view model is doing.
  ///
  ///Example:
  ///```dart
  ///Future<void> loadUsers() async {
  ///    final users = await doAsync<User>(
  ///      () async => await userService.getAll(),
  ///      busyTaskKey: 'loadingUsers'
  ///    );
  ///}
  ///```
  Future<T> doAsync<T>(Future<T> Function() work, {dynamic busyTaskKey}) async {
    setBusyStatus(isBusy: true, busyTaskKey: busyTaskKey);

    try {
      final result = await work();
      return result;
    } finally {
      setBusyStatus(isBusy: false, busyTaskKey: busyTaskKey);
    }
  }

  ///Checks if the view model is busy working on a specific task.
  ///
  ///See [doAsync] for [busyTaskKey] usage.
  bool isTaskInProgress(dynamic busyTaskKey) => _busyTaskKeys.contains(busyTaskKey);

  void _addBusyTaskKey(dynamic busyTaskKey) {
    if (busyTaskKey != null) {
      _busyTaskKeys.add(busyTaskKey);
    }
  }

  void _removeBusyTaskKey(dynamic busyTaskKey) {
    if (busyTaskKey != null && _busyTaskKeys.contains(busyTaskKey)) {
      _busyTaskKeys.remove(busyTaskKey);
    }
  }

  ///Short hand helper function for initializing an [EmpireProperty].
  ///
  ///See [EmpireProperty] for [propertyName] usages.
  ///
  ///## Example
  ///
  ///```dart
  ///late final EmpireProperty<String> name;
  ///
  ///name = createProperty('Bob');
  ///```
  EmpireProperty<T> createProperty<T>(T value, {String? propertyName}) {
    return EmpireProperty<T>(value, this, propertyName: propertyName);
  }

  ///Short hand helper function for initializing an [EmpireProperty] with a null value.
  ///
  ///See [EmpireProperty] for [propertyName] usages.
  ///
  ///## Example
  ///
  ///```dart
  ///late final EmpireProperty<String?> name;
  ///
  ///name = createNullProperty();
  ///
  ///```
  EmpireProperty<T?> createNullProperty<T>({String? propertyName}) {
    return createProperty(null, propertyName: propertyName);
  }

  ///Closes the state and error streams and removes any listeners associated with those streams
  @mustCallSuper
  void dispose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _errorController.close();
    _stateController.close();
  }
}

///The event that is added to the State stream.
///
///Any event handlers registered with the
///[EmpireViewModel.addOnStateChangedListener] function will receive these types of events
class EmpireStateChanged<T> {
  final T? previousValue;
  final T? nextValue;
  final String? propertyName;
  final String? description;

  EmpireStateChanged(this.nextValue, this.previousValue, {this.propertyName, this.description});

  static EmpireStateChanged addedToList<V>(V newValue, {String? propertyName}) =>
      EmpireStateChanged(newValue, null, propertyName: propertyName, description: 'Added To List: $newValue');

  static EmpireStateChanged addedAllToList<V>(Iterable<V> newValues, {String? propertyName}) =>
      EmpireStateChanged(newValues, null,
          propertyName: propertyName, description: 'Added All To List: $newValues');

  static EmpireStateChanged removedFromList<V>(V removedValue, {String? propertyName}) =>
      EmpireStateChanged(null, removedValue,
          propertyName: propertyName, description: 'Removed From List: $removedValue');

  static EmpireStateChanged<Iterable<V>> clearedList<V>(Iterable<V> iterable, {String? propertyName}) =>
      EmpireStateChanged(<V>[], iterable, propertyName: propertyName, description: 'Iterable Cleared');

  static EmpireStateChanged addedMapToMap<K, V>(Map<K, V> addedMap, {String? propertyName}) {
    return EmpireStateChanged(addedMap, null,
        propertyName: propertyName, description: 'Added Map To Map: $addedMap');
  }

  static EmpireStateChanged addedToMap<K, V>(K key, V newValue, {String? propertyName}) {
    final newEntry = MapEntry(key, newValue);
    return EmpireStateChanged(newEntry, null,
        propertyName: propertyName, description: 'Added To Map: $newEntry');
  }

  static EmpireStateChanged addedEntriesToMap<K, V>(Iterable<MapEntry<K, V>> entries,
      {String? propertyName}) {
    return EmpireStateChanged(entries, null,
        propertyName: propertyName, description: 'Added Entries To Map: $entries');
  }

  static EmpireStateChanged<V> updateMapEntry<K, V>(K key, V? originalValue, V? nextValue,
      {String? propertyName}) {
    return EmpireStateChanged<V>(nextValue, originalValue,
        propertyName: propertyName, description: 'Update Map Value For Key: $key');
  }

  static EmpireStateChanged<V> removedFromMap<K, V>(K key, V removedValue, {String? propertyName}) {
    final removedEntry = MapEntry(key, removedValue);
    return EmpireStateChanged<V>(null, removedValue,
        propertyName: propertyName, description: 'Removed From Map: $removedEntry');
  }

  @override
  String toString() {
    return 'Previous: $previousValue, Next: $nextValue, Property Name: $propertyName, Description: $description';
  }
}

///The event that is added to the Error stream.
///
///Any event handlers registered with the [EmpireViewModel.addOnStateChangedListener] function will
///receive these types of events. The [metaData] property can be used to store any additional
///information you may want your error event handler to have access to.
class ErrorEvent<T> {
  final T error;
  final StackTrace? stackTrace;
  final Map<dynamic, dynamic> metaData;

  ///Tries to get a value from the [metaData] map by key.
  ///
  ///Returns `null` if the [key] is not found in the [metaData] map.
  E? getMetaData<E>(dynamic key) {
    if (metaData.containsKey(key)) {
      return metaData[key] as E;
    }
    return null;
  }

  ErrorEvent(this.error, {this.stackTrace, this.metaData = const {}});

  @override
  String toString() => 'Exception: ${error.toString()}\nStackTrace: $stackTrace';
}
