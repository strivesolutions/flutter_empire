library empire;

import 'dart:async';

import 'package:flutter/foundation.dart';

///A ViewModel is an abstraction of the view it is bound to and represents the current state of
///the data in your model (data).
///
///This is where any logic that manipulates your model should be. An [EmpireState] and it's
///accompanying state always has access to it's view model via the viewModel property.
///
///Update events are automatically emitted whenever the value of an [EmpireProperty] is changed.
///The [EmpireState] the ViewModel is bound to will update itself each time an [EmpireProperty] value
///is changed and call the states build function, updating the UI
abstract class EmpireViewModel {
  final StreamController<EmpireStateChanged> _stateController = StreamController.broadcast();
  final StreamController<ErrorEvent> _errorController = StreamController.broadcast();
  late final Stream<EmpireStateChanged> _stream;
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

  ///Initializes all [EmpireProperty] properties in the ViewModel. This method is automatically called
  ///during object construction and should not be called manually.
  ///
  ///All [EmpireProperty] properties must be defined with the late final keywords. For example:
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
  void addOnStateChangedListener(Function(EmpireStateChanged) onStateChanged) {
    _subscriptions.add(_stream.listen(onStateChanged));
  }

  ///Adds an event handler which gets executed each time [notifyError] is called
  void addOnErrorEventListener(Function(ErrorEvent) onError) {
    _subscriptions.add(_errorStream.listen(onError));
  }

  ///Inform the bound [EmpireState] that the state of the UI needs to be updated.
  ///
  ///**NOTE**: Although you CAN call this method manually, it's usually not required. Updating the
  ///value of an [EmpireProperty] will automatically notify the UI to update itself.
  void notifyChange(EmpireStateChanged event) {
    _stateController.add(event);
  }

  ///Inform the bound [EmpireState] that an error has occurred. Any event handlers registered by the
  ///[addOnErrorEventListener] function will be executed
  void notifyError(ErrorEvent event) => _errorController.add(event);

  ///Explicitly updates the current busy status of the view model. Can use this in conjunction with the
  ///[ifBusy] function on the [EmpireState] to show a loading indicator when performing a long running
  ///task. Can also determine the current busy status by accessing the [busy] property on the view model.
  ///
  ///[busyTaskKey] can be optionally set to help identify why the view model is busy. This can then
  ///be accessed by the UI to react differently depending on what the view model is doing.
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
      notifyChange(EmpireStateChanged(isBusy, !isBusy));
    }
  }

  ///Executes a long running task asynchronously. Automatically sets the view model [busy] status.
  ///See [setBusyStatus] for usage of the optional [busyTaskKey] argument
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

  ///Checks if the view model is busy working on a specific task. See [setBusyStatus] for [busyTaskKey]
  ///usage.
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

  ///Short hand helper function for initializing an [EmpireProperty]. See [EmpireProperty] for
  ///[propertyName] usages.
  EmpireProperty<T> createProperty<T>(T value, {String? propertyName}) {
    return EmpireProperty<T>(value, this, propertyName: propertyName);
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

abstract class EmpireValue<T> {
  T? get value;
}

///Contains any object that will notify any listeners when its value is changed. Usually these are
///properties that are bound to a UI Widget so when the value changes, the UI is updated.
///
///You optionally set the [propertyName] argument to conditionally perform logic when a specific
///property changes. You can access the [propertyName] in any event listener registered with the
///[addOnStateChangedListener] function via the [propertyName] property on an [EmpireStateChanged] object.
///
///An [EmpireProperty] is callable. Calling the property updates the value. However, there are two
///ways to update the value of an [EmpireProperty]:
///
///*Using [set]*:
///```dart
/////initialize the property value to zero.
///final age = createProperty<int>(0);
///
/////update the property value to five.
///age.set(5);
///```
///
///-----------------------------------------
///
///*Calling the property*:
///```dart
/////initialize the property value to zero.
///final age = createProperty<int>(0);
///
/////update the property value to five.
///age(5);
///```
class EmpireProperty<T> implements EmpireValue<T> {
  String? propertyName;
  T _value;
  @override
  T get value => _value;

  final EmpireViewModel _viewModel;

  EmpireProperty(this._value, this._viewModel, {this.propertyName});

  void call(T value) {
    set(value);
  }

  ///Updates the property value. Notifies any listeners to the change
  void set(T value) {
    final previousValue = _value;
    _value = value;
    _viewModel.notifyChange(EmpireStateChanged(value, previousValue));
  }

  @override
  String toString() => _value?.toString() ?? '';
}

///The event that is added to the State stream. Any event handlers registered with the
///[addOnStateChangedListener] function will receive these types of events
class EmpireStateChanged<T> {
  final T previousValue;
  final T nextValue;
  final String? propertyName;

  EmpireStateChanged(this.nextValue, this.previousValue, {this.propertyName});
}

///The event that is added to the Error stream. Any event handlers registered with the
///[addOnStateChangedListener] function will receive these types of events
class ErrorEvent<T extends Exception> {
  final T error;
  final StackTrace? stackTrace;
  final Map<dynamic, dynamic> metaData;

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
