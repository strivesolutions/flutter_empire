import 'package:empire/empire.dart';
import 'package:flutter/material.dart';

class MapViewModel extends EmpireViewModel {
  late final EmpireMapProperty<String, String> data;

  @override
  void initProperties() {
    data = createEmptyMapProperty();
  }
}

class MapTestWidget extends EmpireWidget<MapViewModel> {
  const MapTestWidget({
    Key? key,
    required MapViewModel viewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  EmpireState<EmpireWidget<EmpireViewModel>, MapViewModel> createEmpire() {
    return _MapTestWidgetState(viewModel);
  }
}

class _MapTestWidgetState extends EmpireState<MapTestWidget, MapViewModel> {
  _MapTestWidgetState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (innerContext) {
            return Center(
              child: Column(
                children: [
                  ...viewModel.data.value.keys.map((e) => Text(e)).toList(),
                  ...viewModel.data.value.values.map((e) => Text(e)).toList()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
