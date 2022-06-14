import 'package:empire/empire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BoolViewModel extends EmpireViewModel {
  late EmpireBoolProperty isAwesome;

  @override
  void initProperties() {
    isAwesome = createBoolProperty(true);
  }
}

class BoolTestWidget extends EmpireWidget<BoolViewModel> {
  const BoolTestWidget({
    Key? key,
    required BoolViewModel viewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  EmpireState<EmpireWidget<EmpireViewModel>, BoolViewModel> createEmpire() {
    return _BoolTestWidgetState(viewModel);
  }
}

class _BoolTestWidgetState extends EmpireState<BoolTestWidget, BoolViewModel> {
  _BoolTestWidgetState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (innerContext) {
            return Center(
              child: Column(
                children: [
                  Text('${viewModel.isAwesome}'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class NullableBoolViewModel extends EmpireViewModel {
  late final EmpireNullableBoolProperty isAwesome;

  @override
  void initProperties() {
    isAwesome = createNullableBoolProperty();
  }
}
