import 'package:empire/empire.dart';
import 'package:flutter/material.dart';

class ListViewModel extends EmpireViewModel {
  late final EmpireListProperty<String> planets;

  @override
  void initProperties() {
    planets = createEmptyListProperty();
  }
}

class ListTestWidget extends EmpireWidget<ListViewModel> {
  const ListTestWidget({
    Key? key,
    required ListViewModel viewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  EmpireState<EmpireWidget<EmpireViewModel>, ListViewModel> createEmpire() {
    return _ListTestWidgetState(viewModel);
  }
}

class _ListTestWidgetState extends EmpireState<ListTestWidget, ListViewModel> {
  _ListTestWidgetState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (innerContext) {
            return Center(
              child: Column(
                children: viewModel.planets.value.map((e) => Text(e)).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
