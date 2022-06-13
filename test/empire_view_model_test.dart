import 'package:empire/empire_state.dart';
import 'package:empire/empire_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestViewModel extends EmpireViewModel {
  late EmpireProperty<String?> name;
  late EmpireProperty<int> age;

  @override
  void initProperties() {
    name = createNullProperty();
    age = createProperty(1);
  }

  void useSetMultiple(String name, int age) {
    setMultiple({
      this.name: name,
      this.age: age,
    });
  }
}

class _MyWidget extends EmpireWidget<_TestViewModel> {
  const _MyWidget({
    Key? key,
    required _TestViewModel viewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  EmpireState<EmpireWidget<EmpireViewModel>, _TestViewModel> createEmpire() {
    return _MyWidgetState(viewModel);
  }
}

class _MyWidgetState extends EmpireState<_MyWidget, _TestViewModel> {
  _MyWidgetState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (innerContext) {
            return Center(
              child: Column(
                children: [
                  Text(viewModel.name.value ?? ''),
                  Text(
                    viewModel.age.value.toString(),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  testWidgets('SetMultiple - All Widgets Update After Multiple Set', (tester) async {
    final viewModel = _TestViewModel();
    viewModel.name('Justin');
    viewModel.age(88);

    await tester.pumpWidget(_MyWidget(
      viewModel: viewModel,
    ));

    expect(find.text("Justin"), findsOneWidget);
    expect(find.text("88"), findsOneWidget);

    const newName = 'Mike';
    const newAge = 20;

    viewModel.useSetMultiple(newName, newAge);

    await tester.pumpAndSettle();

    expect(find.text(newName), findsOneWidget);
    expect(find.text(newAge.toString()), findsOneWidget);
  });
}
