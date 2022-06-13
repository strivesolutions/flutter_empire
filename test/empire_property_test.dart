import 'package:empire/empire.dart';
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
                  Text(viewModel.age.toString()),
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
  late _TestViewModel viewModel;
  late _MyWidget testWidget;
  setUp(() {
    viewModel = _TestViewModel();
    testWidget = _MyWidget(viewModel: viewModel);
  });
  group('Property Reset Tests', () {
    testWidgets('reset - notifyChange is true - UI Updates', (tester) async {
      await tester.pumpWidget(testWidget);

      expect(find.text("1"), findsOneWidget);

      viewModel.age(10);

      await tester.pumpAndSettle();

      expect(find.text("10"), findsOneWidget);

      viewModel.age.reset();

      await tester.pumpAndSettle();

      expect(find.text("1"), findsOneWidget);
    });

    testWidgets('reset - notifyChange is false - UI Does Not Update', (tester) async {
      await tester.pumpWidget(testWidget);

      expect(find.text("1"), findsOneWidget);

      viewModel.age(10);

      await tester.pumpAndSettle();

      expect(find.text("10"), findsOneWidget);

      viewModel.age.reset(notifyChange: false);

      await tester.pumpAndSettle();

      expect(find.text("10"), findsOneWidget);
    });
  });
}
