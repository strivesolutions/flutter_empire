import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:empire/empire.dart';

class TestViewModel extends EmpireViewModel {
  late EmpireProperty<String?> name;

  @override
  void initProperties() {
    name = EmpireProperty(null, this);
  }
}

class MyWidget extends EmpireWidget<TestViewModel> {
  const MyWidget({
    Key? key,
    required TestViewModel viewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  EmpireState<EmpireWidget<EmpireViewModel>, TestViewModel> createEmpire() {
    return _MyWidgetState(viewModel);
  }
}

class _MyWidgetState extends EmpireState<MyWidget, TestViewModel> {
  _MyWidgetState(super.viewModel);

  @override
  Widget render(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text(viewModel.name.value ?? '')),
      ),
    );
  }
}

void main() {
  testWidgets('Test', (tester) async {
    final viewModel = TestViewModel();
    viewModel.name("Justin");
    await tester.pumpWidget(MyWidget(
      viewModel: viewModel,
    ));

    final text = find.text("Justin");
    expect(text, findsOneWidget);

    viewModel.name("Shep");
    await tester.pumpAndSettle();

    final textTwo = find.text("Shep");
    expect(textTwo, findsOneWidget);
  });
}
