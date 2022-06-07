library empire;

import 'dart:async';

abstract class EmpireViewModel {
  final StreamController<EmpireStateChanged> _stateController = StreamController.broadcast();

  late final Stream<EmpireStateChanged> _stream;

  final List<StreamSubscription> _subscriptions = [];

  bool _busy = false;
  bool get busy => _busy;

  EmpireViewModel() {
    _stream = _stateController.stream;
    initProperties();
  }

  void initProperties();

  void listen(Function(EmpireStateChanged) onStateChanged) {
    _subscriptions.add(_stream.listen(onStateChanged));
  }

  void notify(EmpireStateChanged event) {
    _stateController.add(event);
  }

  Future<void> doAsync(Future<void> Function() work) async {
    _busy = true;
    notify(EmpireStateChanged(true, false));
    await work();
    _busy = false;
    notify(EmpireStateChanged(false, true));
  }

  EmpireProperty<T> createProperty<T>(T value, {String? propertyName}) {
    return EmpireProperty<T>(value, this, propertyName: propertyName);
  }

  void dispose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
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
    _viewModel.notify(EmpireStateChanged(value, previousValue));
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
