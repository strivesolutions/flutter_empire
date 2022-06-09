import 'package:empire/empire_widget.dart';
import 'package:empire/empire_state.dart';
import 'package:empire/empire_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class ApplicationViewModel extends EmpireViewModel {
  late EmpireProperty<bool> changed;

  @override
  void initProperties() {
    changed = createProperty(false, propertyName: 'changed');
  }

  void change() => changed(!changed.value);
}

class TestViewModel extends EmpireViewModel {
  late EmpireProperty<String?> name;

  @override
  void initProperties() {
    name = EmpireProperty(null, this);
  }
}

class MyWidget extends EmpireWidget<TestViewModel> {
  final ApplicationViewModel applicationViewModel;
  const MyWidget({
    Key? key,
    required TestViewModel viewModel,
    required this.applicationViewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  EmpireState<EmpireWidget<EmpireViewModel>, TestViewModel> createEmpire() {
    return _MyWidgetState(viewModel);
  }
}

class _MyWidgetState extends EmpireState<MyWidget, TestViewModel> {
  _MyWidgetState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return Empire<ApplicationViewModel>(
      widget.applicationViewModel,
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (innerContext) {
              return Center(
                child: Column(
                  children: [
                    Text(viewModel.name.value ?? ''),
                    Text('${Empire.of(innerContext).viewModel<ApplicationViewModel>().changed}')
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('Test', (tester) async {
    final viewModel = TestViewModel();
    final appViewModel = ApplicationViewModel();
    viewModel.name("Justin");
    await tester.pumpWidget(MyWidget(
      viewModel: viewModel,
      applicationViewModel: appViewModel,
    ));

    final text = find.text("Justin");
    expect(text, findsOneWidget);

    viewModel.name("Shep");
    await tester.pumpAndSettle();

    final textTwo = find.text("Shep");
    expect(textTwo, findsOneWidget);
  });

  testWidgets('Test Application', (tester) async {
    final viewModel = TestViewModel();
    final appViewModel = ApplicationViewModel();
    await tester.pumpWidget(MyWidget(
      viewModel: viewModel,
      applicationViewModel: appViewModel,
    ));

    final text = find.text("false");
    expect(text, findsOneWidget);

    appViewModel.change();

    await tester.pumpAndSettle();

    final textTwo = find.text("true");
    expect(textTwo, findsOneWidget);
  });
}
