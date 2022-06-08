library empire;

import 'dart:async';

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

  void initProperties();

  void addOnStateChangedListener(Function(EmpireStateChanged) onStateChanged) {
    _subscriptions.add(_stream.listen(onStateChanged));
  }

  void addOnErrorEventListener(Function(ErrorEvent) onError) {
    _subscriptions.add(_errorStream.listen(onError));
  }

  void notifyChange(EmpireStateChanged event) {
    _stateController.add(event);
  }

  void notifyError(ErrorEvent event) => _errorController.add(event);

  void setBusyStatus({required bool isBusy, dynamic busyTaskKey}) {
    if (_busy != isBusy) {
      if (isBusy) {
        addBusyTaskKey(busyTaskKey);
      } else {
        removeBusyTaskKey(busyTaskKey);
      }
      _busy = isBusy;
      notifyChange(EmpireStateChanged(isBusy, !isBusy));
    }
  }

  Future<T> doAsync<T>(Future<T> Function() work, {dynamic busyTaskKey}) async {
    setBusyStatus(isBusy: true, busyTaskKey: busyTaskKey);

    try {
      final result = await work();
      return result;
    } finally {
      setBusyStatus(isBusy: false, busyTaskKey: busyTaskKey);
    }
  }

  bool isTaskInProgress(dynamic busyTaskKey) => _busyTaskKeys.contains(busyTaskKey);

  void addBusyTaskKey(dynamic busyTaskKey) {
    if (busyTaskKey != null) {
      _busyTaskKeys.add(busyTaskKey);
    }
  }

  void removeBusyTaskKey(dynamic busyTaskKey) {
    if (busyTaskKey != null && _busyTaskKeys.contains(busyTaskKey)) {
      _busyTaskKeys.remove(busyTaskKey);
    }
  }

  EmpireProperty<T> createProperty<T>(T value, {String? propertyName}) {
    return EmpireProperty<T>(value, this, propertyName: propertyName);
  }

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

class EmpireProperty<T> implements EmpireValue<T> {
  String? propertyName;
  T _value;
  @override
  T get value => _value;

  final EmpireViewModel _viewModel;

  EmpireProperty(this._value, this._viewModel, {this.propertyName});

  void call(T value) {
    final previousValue = _value;
    _value = value;
    _viewModel.notifyChange(EmpireStateChanged(value, previousValue));
  }

  @override
  String toString() => _value?.toString() ?? '';
}

class EmpireStateChanged<T> {
  final T previousValue;
  final T nextValue;
  final String? propertyName;

  EmpireStateChanged(this.nextValue, this.previousValue, {this.propertyName});
}

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
