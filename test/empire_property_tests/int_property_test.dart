import 'package:empire/empire_properties.dart';
import 'package:empire/empire_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class IntViewModel extends EmpireViewModel {
  final age = EmpireIntProperty(10);

  @override
  Iterable<EmpireProperty> get props => [age];
}

class IntTestWidget extends EmpireWidget<IntViewModel> {
  const IntTestWidget({
    Key? key,
    required IntViewModel viewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  EmpireState<EmpireWidget<EmpireViewModel>, IntViewModel> createEmpire() {
    return _IntTestWidgetState(viewModel);
  }
}

class _IntTestWidgetState extends EmpireState<IntTestWidget, IntViewModel> {
  _IntTestWidgetState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (innerContext) {
            return Center(
              child: Column(
                children: [
                  Text('${viewModel.age}'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class NullableIntViewModel extends EmpireViewModel {
  final age = EmpireNullableIntProperty(10);

  @override
  Iterable<EmpireProperty> get props => [age];
}

void main() {
  group('EmpireIntProperty Tests', () {
    late IntViewModel viewModel;
    late IntTestWidget testWidget;

    setUp(() {
      viewModel = IntViewModel();
      testWidget = IntTestWidget(viewModel: viewModel);
    });

    testWidgets('int value changes - widget updates', (tester) async {
      const int expectedValue = 20;

      await tester.pumpWidget(testWidget);

      expect(find.text(viewModel.age.toString()), findsOneWidget);

      viewModel.age(expectedValue);

      await tester.pumpAndSettle();

      expect(find.text(expectedValue.toString()), findsOneWidget);
    });

    testWidgets('addition - widget updates', (tester) async {
      const int expectedValue = 15;
      const int startingValue = 10;
      const int addend = 5;

      viewModel.age(startingValue);

      await tester.pumpWidget(testWidget);

      expect(find.text(viewModel.age.toString()), findsOneWidget);

      final result = viewModel.age + addend;

      viewModel.age(result);
      await tester.pumpAndSettle();

      expect(find.text(expectedValue.toString()), findsOneWidget);
      expect(result, equals(expectedValue));
    });

    testWidgets('subtraction - widget updates', (tester) async {
      const int expectedValue = 5;
      const int startingValue = 10;
      const int subtrahend = 5;

      viewModel.age(startingValue);

      await tester.pumpWidget(testWidget);

      expect(find.text(viewModel.age.toString()), findsOneWidget);

      final result = viewModel.age - subtrahend;

      viewModel.age(result);

      await tester.pumpAndSettle();

      expect(find.text(expectedValue.toString()), findsOneWidget);
      expect(result, equals(expectedValue));
    });

    testWidgets('multiplication - widget updates', (tester) async {
      const int expectedValue = 50;
      const int startingValue = 10;
      const int multiplier = 5;

      viewModel.age(startingValue);

      await tester.pumpWidget(testWidget);

      expect(find.text(viewModel.age.toString()), findsOneWidget);

      final result = viewModel.age * multiplier;

      viewModel.age(result);

      await tester.pumpAndSettle();

      expect(find.text(expectedValue.toString()), findsOneWidget);
      expect(result, equals(expectedValue));
    });

    testWidgets('division - widget updates', (tester) async {
      const int expectedValue = 2;
      const int startingValue = 10;
      const int multiplier = 5;

      viewModel.age(startingValue);

      await tester.pumpWidget(testWidget);

      expect(find.text(viewModel.age.toString()), findsOneWidget);

      final result = viewModel.age / multiplier;

      viewModel.age(result);

      await tester.pumpAndSettle();

      expect(find.text(expectedValue.toString()), findsOneWidget);
      expect(result, equals(expectedValue));
    });

    test('isOdd - number is odd - returns true', () {
      viewModel.age(3);
      final result = viewModel.age.isOdd;
      expect(result, isTrue);
    });

    test('isOdd - number is not odd - returns false', () {
      viewModel.age(2);
      final result = viewModel.age.isOdd;
      expect(result, isFalse);
    });

    test('isEven - number is even - returns true', () {
      viewModel.age(2);
      final result = viewModel.age.isEven;
      expect(result, isTrue);
    });

    test('isEven - number is not even - returns true', () {
      viewModel.age(3);
      final result = viewModel.age.isEven;
      expect(result, isFalse);
    });

    test('isNegative - number is negative - returns true', () {
      viewModel.age(-3);
      final result = viewModel.age.isNegative;
      expect(result, isTrue);
    });

    test('isNegative - number is not negative - returns true', () {
      viewModel.age(3);
      final result = viewModel.age.isNegative;
      expect(result, isFalse);
    });
  });
}
