library empire;

import 'package:flutter/material.dart';

import 'empire_view_model.dart';

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
  bool get isBusy => viewModel.busy;

  EmpireState(this.viewModel) {
    viewModel.addOnStateChangedListener((_) {
      setState(() {});
    });
  }

  Widget ifBusy(Widget busyIndicator, {required Widget otherwise}) {
    return isBusy ? busyIndicator : otherwise;
  }

  @override
  @mustCallSuper
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
