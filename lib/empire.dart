library empire;

import 'dart:async';

import 'package:flutter/material.dart';

abstract class EmpireWidget<T extends EmpireViewModel> extends StatefulWidget {
  final T viewModel;

  const EmpireWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  EmpireState<EmpireWidget, T> createEmpire();

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return createEmpire();
  }
}

abstract class EmpireState<T extends EmpireWidget, E extends EmpireViewModel> extends State<T> {
  final E viewModel;

  EmpireState(this.viewModel) {
    viewModel.listen((_) {
      setState(() {});
    });
  }

  Widget render(BuildContext context);

  @override
  @mustCallSuper
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return render(context);
  }
}

abstract class EmpireViewModel {
  final StreamController<EmpireStateChanged> _stateController = StreamController.broadcast();
  late final Stream<EmpireStateChanged> _stream;
  final List<StreamSubscription> _subscriptions = [];

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
  T _value;
  @override
  T get value => _value;

  final EmpireViewModel _viewModel;

  EmpireProperty(this._value, this._viewModel);

  void call(T value) {
    final previousValue = _value;
    _value = value;
    _viewModel.notify(EmpireStateChanged(value, previousValue));
  }
}

class EmpireStateChanged<T> {
  final T previousValue;
  final T nextValue;

  EmpireStateChanged(this.nextValue, this.previousValue);
}
