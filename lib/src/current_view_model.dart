import 'dart:async';

import 'package:current/src/current_exceptions.dart';
import 'package:flutter/foundation.dart';

import 'current_property.dart';

///A ViewModel is an abstraction of the view it is bound to and represents the current state of
///the data in your model.
///
///This is where any logic that manipulates your model should be. An [CurrentWidget] and it's
///accompanying state always has access to it's view model via the viewModel property.
///
///Update events are automatically emitted whenever the value of an [CurrentProperty] is changed.
///The [CurrentState] the ViewModel is bound to will update itself each time an [CurrentProperty] value
///is changed and call the states build function, updating the UI.
abstract class CurrentViewModel {
  final StreamController<List<CurrentStateChanged>> _stateController =
      StreamController.broadcast();
  final StreamController<ErrorEvent> _errorController =
      StreamController.broadcast();

  final List<StreamSubscription> _subscriptions = [];

  bool _busy = false;
  bool get busy => _busy;

  final List<dynamic> _busyTaskKeys = [];
  List<dynamic> get activeTasks => _busyTaskKeys;

  int? _assignedTo;

  /// The [CurrentWidget] that the view model is currently assigned to
  int? get assignedTo => _assignedTo;

  /// Whether the view model has already been assigned to a widget
  ///
  /// This is used to prevent the view model from being assigned to multiple widgets
  bool get assignedToWidget => _assignedTo != null;

  CurrentViewModel() {
    for (var element in currentProps) {
      element.setViewModel(this);
    }
  }

  ///Provides a list of [CurrentProperty] fields in the [CurrentViewModel].
  ///
  ///Properties on the implementation must be added to this list in order to be reactive and update the UI on change.
  Iterable<CurrentProperty> get currentProps;

  ///Creates associates the view model with a specific [CurrentWidget] via the widgets hash code.
  ///
  ///This method is called automatically by the [CurrentState] when the view model is assigned to a widget.
  ///
  ///**This method should not be called manually.**
  void assignTo(int widgetHash) {
    if (assignedToWidget) {
      throw CurrentViewModelAlreadyAssignedException(
        StackTrace.current,
        runtimeType,
      );
    }
    _assignedTo = widgetHash;
  }

  ///Adds an event handler which gets executed each time an [CurrentProperty] value is changed.
  ///
  ///If your listener references a [BuildContext] inside of a [Widget],
  ///you should override the [Widget] dispose method and cancel the subscription.
  StreamSubscription addOnStateChangedListener(
      Function(List<CurrentStateChanged> events) onStateChanged) {
    final newSubscription = _stateController.stream.listen(onStateChanged);
    _subscriptions.add(newSubscription);
    return newSubscription;
  }

  ///Cancels the subscription. The subscriber will stop receiving events
  Future<void> cancelSubscription(StreamSubscription? subscription) async {
    await subscription?.cancel();
    _subscriptions.remove(subscription);
  }

  ///Adds an event handler which gets executed each time [notifyError] is called.
  StreamSubscription addOnErrorEventListener(
      Function(ErrorEvent event) onError) {
    final newSubscription = _errorController.stream.listen(onError);
    _subscriptions.add(newSubscription);
    return newSubscription;
  }

  ///Inform the bound [CurrentState] that the state of the UI needs to be updated.
  ///
  ///**NOTE**: Although you CAN call this method manually, it's usually not required. Updating the
  ///value of an [CurrentProperty] will automatically notify the UI to update itself.
  void notifyChanges(List<CurrentStateChanged> events) {
    if (_stateController.isClosed) {
      return;
    }

    _stateController.add(events);
  }

  ///Set multiple [CurrentProperty] values, but only trigger a single state change
  ///
  ///The [setters] is a list of maps, where the keys are the properties you want to set, and the values are the new
  ///values for each property. Each map in the list must contain exactly one key/value pair.
  ///
  ///## Usage
  ///
  ///```dart
  ///late final CurrentProperty<String> name;
  ///late final CurrentProperty<int> age;
  ///
  ///setMultiple([
  ///   {name: 'Doug'},
  ///   {age: 45},
  ///]);
  ///```
  void setMultiple(List<Map<CurrentProperty, dynamic>> setters) {
    final List<CurrentStateChanged> changes = [];
    for (var setter in setters) {
      assert(setter.keys.length == 1,
          'Each setter item must contain exactly one key/value pair.');
      final property = setter.keys.first;

      final previousValue = property.value;
      final nextValue = setter.values.first;

      changes.add(CurrentStateChanged(nextValue, previousValue,
          propertyName: property.propertyName));

      property(nextValue, notifyChange: false);
    }
    notifyChanges(changes);
  }

  ///Inform the bound [CurrentState] that an error has occurred.
  ///
  ///Any event handlers registered by the
  ///[addOnErrorEventListener] function will be executed
  void notifyError(ErrorEvent event) {
    if (_errorController.isClosed) {
      return;
    }

    _errorController.add(event);
  }

  ///Explicitly updates the current busy status of the view model.
  ///
  ///Can use this in conjunction with the [CurrentState.ifBusy] function on the [CurrentState] to show
  ///a loading indicator when performing a long running task. Can also determine the current busy
  ///status by accessing the [busy] property on the view model.
  ///
  ///See [doAsync] for [busyTaskKey] usage.
  ///
  ///Updating the busy status is automatic when using the [doAsync] function.
  void setBusyStatus({required bool isBusy, dynamic busyTaskKey}) {
    if (_busy != isBusy || busyTaskKey != null) {
      if (isBusy) {
        _addBusyTaskKey(busyTaskKey);
      } else {
        _removeBusyTaskKey(busyTaskKey);
      }
      _busy = _busyTaskKeys.isNotEmpty || isBusy;
      notifyChanges([CurrentStateChanged(isBusy, !isBusy)]);
    }
  }

  ///Sets the busy status to `true`
  ///
  ///[busyTaskKey] can be optionally set to help identify why the view model is busy. This can then
  ///be accessed by the UI to react differently depending on what the view model is doing.
  void setBusy({dynamic busyTaskKey}) {
    setBusyStatus(isBusy: true, busyTaskKey: busyTaskKey);
  }

  ///Sets the busy status to `false`
  ///
  ///[busyTaskKey] can be optionally set to help identify why the view model is busy. This can then
  ///be accessed by the UI to react differently depending on what the view model is doing.
  void setNotBusy({dynamic busyTaskKey}) {
    setBusyStatus(isBusy: false, busyTaskKey: busyTaskKey);
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
  bool isTaskInProgress(dynamic busyTaskKey) =>
      _busyTaskKeys.contains(busyTaskKey);

  void _addBusyTaskKey(dynamic busyTaskKey) {
    if (busyTaskKey != null && !_busyTaskKeys.contains(busyTaskKey)) {
      _busyTaskKeys.add(busyTaskKey);
    }
  }

  void _removeBusyTaskKey(dynamic busyTaskKey) {
    if (busyTaskKey != null && _busyTaskKeys.contains(busyTaskKey)) {
      _busyTaskKeys.remove(busyTaskKey);
    }
  }

  ///Resets the value of all properties defined in the [currentProps] list
  ///to their original value.
  ///
  void resetAll() {
    final resetActions = <Map<CurrentProperty, dynamic>>[];
    for (final prop in currentProps) {
      resetActions.add({prop: prop.originalValue});
    }

    setMultiple(resetActions);
  }

  ///Closes the state and error streams and removes any listeners associated with those streams
  @mustCallSuper
  void dispose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    _errorController.close();
    _stateController.close();
  }
}

///The event that is added to the State stream.
///
///Any event handlers registered with the
///[CurrentViewModel.addOnStateChangedListener] function will receive these types of events
class CurrentStateChanged<T> {
  final T? previousValue;
  final T? nextValue;
  final String? propertyName;
  final String? description;

  CurrentStateChanged(this.nextValue, this.previousValue,
      {this.propertyName, this.description});

  ///A factory method which creates a single [CurrentStateChanged] object with a description
  ///describing what value was added to the list
  static CurrentStateChanged addedToList<V>(V newValue,
          {String? propertyName}) =>
      CurrentStateChanged(newValue, null,
          propertyName: propertyName, description: 'Added To List: $newValue');

  ///A factory method which creates a single [CurrentStateChanged] object with a description
  ///describing all the values that were added to the list
  static CurrentStateChanged addedAllToList<V>(Iterable<V> newValues,
          {String? propertyName}) =>
      CurrentStateChanged(newValues, null,
          propertyName: propertyName,
          description: 'Added All To List: $newValues');

  ///A factory method which creates a single [CurrentStateChanged] object with a description
  ///describing the value inserted into to the list at the specified index
  static CurrentStateChanged insertIntoList<V>(int index, V value,
          {String? propertyName}) =>
      CurrentStateChanged(
        value,
        null,
        propertyName: propertyName,
        description: 'Inserted $value into List as index $index',
      );

  ///A factory method which creates a single [CurrentStateChanged] object with a description
  ///describing all the values that were inserted into the list at the specified index
  static CurrentStateChanged insertAllIntoList<V>(int index, Iterable<V> values,
          {String? propertyName}) =>
      CurrentStateChanged(values, null,
          propertyName: propertyName,
          description: 'Inserted All $values into List as index $index');

  ///A factory method which creates a single [CurrentStateChanged] object with a description
  ///describing what value was removed from the list
  static CurrentStateChanged removedFromList<V>(V removedValue,
          {String? propertyName}) =>
      CurrentStateChanged(null, removedValue,
          propertyName: propertyName,
          description: 'Removed From List: $removedValue');

  ///A factory method which creates a single [CurrentStateChanged] object with a description
  ///stating that the entire list was cleared
  static CurrentStateChanged<Iterable<V>> clearedList<V>(Iterable<V> iterable,
          {String? propertyName}) =>
      CurrentStateChanged(<V>[], iterable,
          propertyName: propertyName, description: 'Iterable Cleared');

  ///A factory method which creates a single [CurrentStateChanged] object with a description
  ///describing what new map values were added to another map
  static CurrentStateChanged addedMapToMap<K, V>(Map<K, V> addedMap,
      {String? propertyName}) {
    return CurrentStateChanged(addedMap, null,
        propertyName: propertyName, description: 'Added Map To Map: $addedMap');
  }

  ///A factory method which creates a single [CurrentStateChanged] object with a description
  ///describing what key/value was added to the map
  static CurrentStateChanged addedToMap<K, V>(K key, V newValue,
      {String? propertyName}) {
    final newEntry = MapEntry(key, newValue);
    return CurrentStateChanged(newEntry, null,
        propertyName: propertyName, description: 'Added To Map: $newEntry');
  }

  ///A factory method which creates a single [CurrentStateChanged] object with a description
  ///describing what [MapEntry] objects were added to the map
  static CurrentStateChanged addedEntriesToMap<K, V>(
      Iterable<MapEntry<K, V>> entries,
      {String? propertyName}) {
    return CurrentStateChanged(entries, null,
        propertyName: propertyName,
        description: 'Added Entries To Map: $entries');
  }

  ///A factory method which creates a single [CurrentStateChanged] object with a description
  ///describing what changes were made to a map entry, including for which key
  static CurrentStateChanged<V> updateMapEntry<K, V>(
      K key, V? originalValue, V? nextValue,
      {String? propertyName}) {
    return CurrentStateChanged<V>(nextValue, originalValue,
        propertyName: propertyName,
        description: 'Update Map Value For Key: $key');
  }

  ///A factory method which creates a single [CurrentStateChanged] object with a description
  ///describing what key/value was removed from the map
  static CurrentStateChanged<V> removedFromMap<K, V>(K key, V removedValue,
      {String? propertyName}) {
    final removedEntry = MapEntry(key, removedValue);
    return CurrentStateChanged<V>(null, removedValue,
        propertyName: propertyName,
        description: 'Removed From Map: $removedEntry');
  }

  @override
  String toString() {
    return 'Previous: $previousValue, Next: $nextValue, Property Name: $propertyName, Description: $description';
  }
}

extension CurrentStateChangedExtensions<T> on List<CurrentStateChanged<T>> {
  ///Whether the propertyName on any event matches the [propertyName] argument
  bool containsPropertyName(String propertyName) {
    return map((x) => x.propertyName).contains(propertyName);
  }

  ///Gets the first event where the [CurrentStateChanged.propertyName] matches the
  ///[propertyName] argument
  ///
  ///Returns null if no event is found
  CurrentStateChanged<T>? firstForPropertyName(String propertyName) {
    final events = where((e) => e.propertyName == propertyName);

    return events.isNotEmpty ? events.first : null;
  }

  ///Gets the [CurrentStateChanged.nextValue] for the first event where the [CurrentStateChanged.propertyName]
  ///matches the [propertyName] argument
  T? nextValueFor(String propertyName) {
    return firstForPropertyName(propertyName)?.nextValue;
  }

  ///Gets the [CurrentStateChanged.previousValue] for the first event where the [CurrentStateChanged.propertyName]
  ///matches the [propertyName] argument
  T? previousValueFor(String propertyName) {
    return firstForPropertyName(propertyName)?.previousValue;
  }
}

///The event that is added to the Error stream.
///
///Any event handlers registered with the [CurrentViewModel.addOnStateChangedListener] function will
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
  String toString() =>
      'Exception: ${error.toString()}\nStackTrace: $stackTrace';
}
