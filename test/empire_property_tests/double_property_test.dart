import 'package:empire/empire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class DoubleViewModel extends EmpireViewModel {
  final percentage = EmpireDoubleProperty(10.0);

  @override
  Iterable<EmpireProperty> get empireProps => [percentage];
}

class DoubleTestWidget extends EmpireWidget<DoubleViewModel> {
  const DoubleTestWidget({
    Key? key,
    required DoubleViewModel viewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  EmpireState<EmpireWidget<EmpireViewModel>, DoubleViewModel> createEmpire() {
    return _DoubleTestWidgetState(viewModel);
  }
}

class _DoubleTestWidgetState
    extends EmpireState<DoubleTestWidget, DoubleViewModel> {
  _DoubleTestWidgetState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (innerContext) {
            return Center(
              child: Column(
                children: [
                  Text('${viewModel.percentage}'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class NullableDoubleViewModel extends EmpireViewModel {
  final percentage = EmpireNullableDoubleProperty();

  @override
  Iterable<EmpireProperty> get empireProps => [percentage];
}

void main() {
  group('EmpireDoubleProperty Tests', () {
    late DoubleViewModel viewModel;
    late DoubleTestWidget testWidget;

    setUp(() {
      viewModel = DoubleViewModel();
      testWidget = DoubleTestWidget(viewModel: viewModel);
    });

    testWidgets('double value changes - widget updates', (tester) async {
      const double expectedValue = 20;

      await tester.pumpWidget(testWidget);

      expect(find.text(viewModel.percentage.toString()), findsOneWidget);

      viewModel.percentage(expectedValue);

      await tester.pumpAndSettle();

      expect(find.text(expectedValue.toString()), findsOneWidget);
    });

    testWidgets('addition - widget updates', (tester) async {
      const double expectedValue = 10.5;
      const double startingValue = 10;
      const double addend = .5;

      viewModel.percentage(startingValue);

      await tester.pumpWidget(testWidget);

      expect(find.text(viewModel.percentage.toString()), findsOneWidget);

      final result = viewModel.percentage.add(addend);

      viewModel.percentage(result);
      await tester.pumpAndSettle();

      expect(find.text(expectedValue.toString()), findsOneWidget);
      expect(result, equals(expectedValue));
    });

    testWidgets('subtraction - widget updates', (tester) async {
      const double expectedValue = 9.5;
      const double startingValue = 10;
      const double subtrahend = .5;

      viewModel.percentage(startingValue);

      await tester.pumpWidget(testWidget);

      expect(find.text(viewModel.percentage.toString()), findsOneWidget);

      final result = viewModel.percentage.subtract(subtrahend);

      viewModel.percentage(result);

      await tester.pumpAndSettle();

      expect(find.text(expectedValue.toString()), findsOneWidget);
      expect(result, equals(expectedValue));
    });

    testWidgets('multiplication - widget updates', (tester) async {
      const double expectedValue = 21;
      const double startingValue = 10.5;
      const double multiplier = 2;

      viewModel.percentage(startingValue);

      await tester.pumpWidget(testWidget);

      expect(find.text(viewModel.percentage.toString()), findsOneWidget);

      final result = viewModel.percentage.multiply(multiplier);

      viewModel.percentage(result);

      await tester.pumpAndSettle();

      expect(find.text(expectedValue.toString()), findsOneWidget);
      expect(result, equals(expectedValue));
    });

    testWidgets('division - widget updates', (tester) async {
      const double expectedValue = 10.5;
      const double startingValue = 21;
      const double divisor = 2;

      viewModel.percentage(startingValue);

      await tester.pumpWidget(testWidget);

      expect(find.text(viewModel.percentage.toString()), findsOneWidget);

      final result = viewModel.percentage.divide(divisor);

      viewModel.percentage(result);

      await tester.pumpAndSettle();

      expect(find.text(expectedValue.toString()), findsOneWidget);
      expect(result, equals(expectedValue));
    });

    test('round - widget updates', () {
      const double expectedValue = 10;
      const double startingValue = 10.2;

      viewModel.percentage(startingValue);

      final result = viewModel.percentage.round();

      expect(result, equals(expectedValue));
    });

    test('roundToDouble - widget updates', () {
      const double expectedValue = 10.0;
      const double startingValue = 10.23;

      viewModel.percentage(startingValue);

      final result = viewModel.percentage.roundToDouble();

      expect(result, equals(expectedValue));
    });

    test('isNegative - number is negative - returns true', () {
      viewModel.percentage(-3);
      final result = viewModel.percentage.isNegative;
      expect(result, isTrue);
    });

    test('isNegative - number is not negative - returns true', () {
      viewModel.percentage(3);
      final result = viewModel.percentage.isNegative;
      expect(result, isFalse);
    });

    test('add - other is int - returns correct double value', () {
      const expected = 2;
      final number = EmpireDoubleProperty(1);
      final result = number.add(1);

      expect(result, equals(expected));
    });

    test('add - other is double - returns correct double value', () {
      const expected = 2.5;
      final number = EmpireDoubleProperty(1);
      final result = number.add(1.5);

      expect(result, equals(expected));
    });

    test('subtract - other is int - returns correct double value', () {
      const expected = 2;
      final number = EmpireDoubleProperty(3);
      final result = number.subtract(1);

      expect(result, equals(expected));
    });

    test('subtract - other is double - returns correct double value', () {
      const expected = 2.5;
      final number = EmpireDoubleProperty(4);
      final result = number.subtract(1.5);

      expect(result, equals(expected));
    });

    test('multiply - other is int - returns correct double value', () {
      const expected = 4;
      final number = EmpireDoubleProperty(2);
      final result = number.multiply(2);

      expect(result, equals(expected));
    });

    test('multiply - other is double - returns correct double value', () {
      const expected = 5.4;
      final number = EmpireDoubleProperty(2);
      final result = number.multiply(2.7);

      expect(result, equals(expected));
    });

    test('divide - returns correct double value', () {
      const expected = 4.0;
      final number = EmpireDoubleProperty(8);
      final result = number.divide(2);

      expect(result, equals(expected));
    });

    test('mod - other is int - returns correct double value', () {
      const expected = 2;
      final number = EmpireDoubleProperty(5);
      final result = number.mod(3);

      expect(result, equals(expected));
    });

    test('mod - other is double - returns correct double value', () {
      const expected = 1.5;
      final number = EmpireDoubleProperty(5);
      final result = number.mod(3.5);

      expect(result, equals(expected));
    });
  });
}
