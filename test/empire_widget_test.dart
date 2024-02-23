import 'package:empire/empire.dart';
import 'package:empire/src/empire_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:math' as math;

class _ApplicationViewModel extends EmpireViewModel {
  final changed = EmpireProperty<bool>(false, propertyName: 'changed');

  void change() => changed(!changed.value);

  @override
  Iterable<EmpireProperty> get empireProps => [changed];
}

class _ApplicationSubViewModel extends EmpireViewModel {
  final viewModelName = EmpireStringProperty('SubViewModel');

  @override
  Iterable<EmpireProperty> get empireProps => [viewModelName];
}

class _TestViewModel extends EmpireViewModel {
  final firstName = EmpireProperty<String?>(null);
  final lastName = EmpireProperty<String?>(null);
  final age = EmpireIntProperty(1);

  @override
  Iterable<EmpireProperty> get empireProps => [firstName, lastName, age];
}

class _MyWidget extends EmpireWidget<_TestViewModel> {
  final _ApplicationViewModel applicationViewModel;
  final _ApplicationSubViewModel appSubViewModel;
  const _MyWidget({
    Key? key,
    required _TestViewModel viewModel,
    required this.applicationViewModel,
    required this.appSubViewModel,
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
    return Empire<_ApplicationViewModel>(
      widget.applicationViewModel,
      onAppStateChanged: () => math.Random().nextInt(1000000).toString(),
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (outerContext) {
              return Empire(
                widget.appSubViewModel,
                onAppStateChanged: () =>
                    math.Random().nextInt(1000000).toString(),
                child: Builder(builder: (innerContext) {
                  return Center(
                    child: Column(
                      children: [
                        Text(viewModel.firstName.value ?? ''),
                        Text(viewModel.lastName.value ?? ''),
                        Text(
                          viewModel.age.value.toString(),
                        ),
                        Text(
                            '${Empire.of<_ApplicationViewModel>(outerContext).viewModel().changed}'),
                        Text(
                            '${Empire.of<_ApplicationSubViewModel>(innerContext).viewModel().viewModelName}')
                      ],
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TestPreventReassignViewModelWidget extends EmpireWidget<_TestViewModel> {
  final _ApplicationViewModel applicationViewModel;
  final _ApplicationSubViewModel appSubViewModel;
  const _TestPreventReassignViewModelWidget({
    Key? key,
    required _TestViewModel viewModel,
    required this.applicationViewModel,
    required this.appSubViewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  EmpireState<EmpireWidget<EmpireViewModel>, _TestViewModel> createEmpire() =>
      _TestPreventReassignViewModelWidgetState(viewModel);
}

class _TestPreventReassignViewModelWidgetState
    extends EmpireState<_TestPreventReassignViewModelWidget, _TestViewModel> {
  _TestPreventReassignViewModelWidgetState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (_) {
                return _MyWidget(
                    viewModel: viewModel,
                    applicationViewModel: widget.applicationViewModel,
                    appSubViewModel: widget.appSubViewModel);
              });
        },
        child: const Text('Open Dialog'));
  }
}

void main() {
  group('State Changes Testing', () {
    late _MyWidget mainWidget;
    late _TestViewModel viewModel;
    late _ApplicationViewModel appViewModel;
    late _ApplicationSubViewModel subViewModel;
    setUp(() {
      viewModel = _TestViewModel();
      appViewModel = _ApplicationViewModel();
      subViewModel = _ApplicationSubViewModel();
      mainWidget = _MyWidget(
        viewModel: viewModel,
        applicationViewModel: appViewModel,
        appSubViewModel: subViewModel,
      );
    });
    testWidgets(
        'EmpireWidget Test - Finds Correct Text Widget After Property Change',
        (tester) async {
      viewModel.firstName("John");
      await tester.pumpWidget(mainWidget);

      expect(find.text("John"), findsOneWidget);

      viewModel.firstName("Bob");
      await tester.pumpAndSettle();

      expect(find.text("Bob"), findsOneWidget);
    });

    testWidgets(
        'Empire App State Test - Widgets Update on App View Model Change',
        (tester) async {
      await tester.pumpWidget(mainWidget);

      final text = find.text("false");
      expect(text, findsOneWidget);

      appViewModel.change();

      await tester.pumpAndSettle();

      final textTwo = find.text("true");
      expect(textTwo, findsOneWidget);
    });

    testWidgets('Update More Than One Property - All Widgets Update',
        (tester) async {
      const initialFirstName = 'John';
      const initialLastName = 'Smith';
      const initialAge = 88;

      viewModel.firstName(initialFirstName);
      viewModel.lastName(initialLastName);
      viewModel.age(initialAge);

      await tester.pumpWidget(mainWidget);

      expect(find.text(initialFirstName), findsOneWidget);
      expect(find.text(initialLastName), findsOneWidget);
      expect(find.text(initialAge.toString()), findsOneWidget);

      const newFirstName = 'Bob';
      const newLastName = 'Brown';
      const newAge = 20;

      viewModel.setMultiple([
        {viewModel.firstName: newFirstName},
        {viewModel.lastName: newLastName},
        {viewModel.age: newAge},
      ]);

      await tester.pumpAndSettle();

      expect(find.text(newFirstName), findsOneWidget);
      expect(find.text(newLastName), findsOneWidget);
      expect(find.text(newAge.toString()), findsOneWidget);
    });

    testWidgets(
        'Update More Than One Property Starting from Null Keys - All Widgets Update',
        (tester) async {
      await tester.pumpWidget(mainWidget);

      const newFirstName = 'Bob';
      const newLastName = 'Brown';
      const newAge = 20;

      viewModel.setMultiple([
        {viewModel.firstName: newFirstName},
        {viewModel.lastName: newLastName},
        {viewModel.age: newAge},
      ]);

      await tester.pumpAndSettle();

      expect(find.text(newFirstName), findsOneWidget);
      expect(find.text(newLastName), findsOneWidget);
      expect(find.text(newAge.toString()), findsOneWidget);
    });

    testWidgets('EmpireWidget Test - Finds Sub Application View Model',
        (tester) async {
      await tester.pumpWidget(mainWidget);

      expect(find.text(subViewModel.viewModelName.value), findsOneWidget);
    });

    testWidgets('EmpireWidget Test - Finds Sub Application View Model',
        (tester) async {
      await tester.pumpWidget(mainWidget);

      expect(find.text(subViewModel.viewModelName.value), findsOneWidget);
    });

    testWidgets(
        'EmpireWidget Test - Increment EmpireIntProperty - Finds Correct Text Widget After Property Change',
        (tester) async {
      const int initialAge = 10;
      viewModel.age(initialAge);
      await tester.pumpWidget(mainWidget);

      expect(find.text("$initialAge"), findsOneWidget);

      final int newAge = viewModel.age.increment();
      await tester.pumpAndSettle();

      expect(find.text("$newAge"), findsOneWidget);
    });

    testWidgets(
        'EmpireWidget Test - Decrement EmpireIntProperty - Finds Correct Text Widget After Property Change',
        (tester) async {
      const int initialAge = 10;
      viewModel.age(initialAge);
      await tester.pumpWidget(mainWidget);

      expect(find.text("$initialAge"), findsOneWidget);

      final int newAge = viewModel.age.decrement();
      await tester.pumpAndSettle();

      expect(find.text("$newAge"), findsOneWidget);
    });
  });

  group('Exception/Edge Case Testing', () {
    testWidgets(
        'EpireWidget Test - Attemp to share View Model Instance - Throws EmpireViewModelAlreadyAssignedException',
        (tester) async {
      late FlutterErrorDetails errorDetails;
      FlutterError.onError = (details) {
        errorDetails = details;
      };
      _TestViewModel viewModel;
      _ApplicationViewModel appViewModel;
      _ApplicationSubViewModel subViewModel;
      viewModel = _TestViewModel();
      appViewModel = _ApplicationViewModel();
      subViewModel = _ApplicationSubViewModel();

      final rootWidget = MaterialApp(
        home: _TestPreventReassignViewModelWidget(
            viewModel: viewModel,
            applicationViewModel: appViewModel,
            appSubViewModel: subViewModel),
      );

      await tester.pumpWidget(rootWidget);

      final openDialogButton = find.byType(TextButton);

      await tester.tap(openDialogButton);
      await tester.pumpAndSettle();

      FlutterError.onError = FlutterError.dumpErrorToConsole;

      expect(errorDetails, isNotNull);
      expect(errorDetails.exception,
          isInstanceOf<EmpireViewModelAlreadyAssignedException>());
    });
  });
}
