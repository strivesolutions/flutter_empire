import 'package:current/current.dart';
import 'package:current/src/current_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:math' as math;

class _ApplicationViewModel extends CurrentViewModel {
  final changed = CurrentProperty<bool>(false, propertyName: 'changed');

  void change() => changed(!changed.value);

  @override
  Iterable<CurrentProperty> get currentProps => [changed];
}

class _ApplicationSubViewModel extends CurrentViewModel {
  final viewModelName = CurrentStringProperty('SubViewModel');

  @override
  Iterable<CurrentProperty> get currentProps => [viewModelName];
}

class _TestViewModel extends CurrentViewModel {
  final firstName = CurrentProperty<String?>(null);
  final lastName = CurrentProperty<String?>(null);
  final age = CurrentIntProperty(1);

  @override
  Iterable<CurrentProperty> get currentProps => [firstName, lastName, age];
}

class _MyWidget extends CurrentWidget<_TestViewModel> {
  final _ApplicationViewModel applicationViewModel;
  final _ApplicationSubViewModel appSubViewModel;
  const _MyWidget({
    Key? key,
    required _TestViewModel viewModel,
    required this.applicationViewModel,
    required this.appSubViewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  CurrentState<CurrentWidget<CurrentViewModel>, _TestViewModel>
      createCurrent() {
    return _MyWidgetState(viewModel);
  }
}

class _MyWidgetState extends CurrentState<_MyWidget, _TestViewModel> {
  _MyWidgetState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return Current<_ApplicationViewModel>(
      widget.applicationViewModel,
      onAppStateChanged: () => math.Random().nextInt(1000000).toString(),
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (outerContext) {
              return Current(
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
                            '${Current.of<_ApplicationViewModel>(outerContext).viewModel().changed}'),
                        Text(
                            '${Current.of<_ApplicationSubViewModel>(innerContext).viewModel().viewModelName}')
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

class _TestPreventReassignViewModelWidget
    extends CurrentWidget<_TestViewModel> {
  final _ApplicationViewModel applicationViewModel;
  final _ApplicationSubViewModel appSubViewModel;
  const _TestPreventReassignViewModelWidget({
    Key? key,
    required _TestViewModel viewModel,
    required this.applicationViewModel,
    required this.appSubViewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  CurrentState<CurrentWidget<CurrentViewModel>, _TestViewModel>
      createCurrent() => _TestPreventReassignViewModelWidgetState(viewModel);
}

class _TestPreventReassignViewModelWidgetState
    extends CurrentState<_TestPreventReassignViewModelWidget, _TestViewModel> {
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
        'CurrentWidget Test - Finds Correct Text Widget After Property Change',
        (tester) async {
      viewModel.firstName("John");
      await tester.pumpWidget(mainWidget);

      expect(find.text("John"), findsOneWidget);

      viewModel.firstName("Bob");
      await tester.pumpAndSettle();

      expect(find.text("Bob"), findsOneWidget);
    });

    testWidgets(
        'Current App State Test - Widgets Update on App View Model Change',
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

    testWidgets('CurrentWidget Test - Finds Sub Application View Model',
        (tester) async {
      await tester.pumpWidget(mainWidget);

      expect(find.text(subViewModel.viewModelName.value), findsOneWidget);
    });

    testWidgets('CurrentWidget Test - Finds Sub Application View Model',
        (tester) async {
      await tester.pumpWidget(mainWidget);

      expect(find.text(subViewModel.viewModelName.value), findsOneWidget);
    });

    testWidgets(
        'CurrentWidget Test - Increment CurrentIntProperty - Finds Correct Text Widget After Property Change',
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
        'CurrentWidget Test - Decrement CurrentIntProperty - Finds Correct Text Widget After Property Change',
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
        'EpireWidget Test - Attemp to share View Model Instance - Throws CurrentViewModelAlreadyAssignedException',
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
          isInstanceOf<CurrentViewModelAlreadyAssignedException>());
    });
  });
}
