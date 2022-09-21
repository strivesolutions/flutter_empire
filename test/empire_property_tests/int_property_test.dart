import 'package:empire/empire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class IntViewModel extends EmpireViewModel {
  final age = EmpireIntProperty(10);

  @override
  Iterable<EmpireProperty> get empireProps => [age];
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
  final age = EmpireNullableIntProperty(value: 10);

  @override
  Iterable<EmpireProperty> get empireProps => [age];
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

      final result = viewModel.age.add(addend);

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

      final result = viewModel.age.subtract(subtrahend);

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

      final result = viewModel.age.multiply(multiplier);

      viewModel.age(result);

      await tester.pumpAndSettle();

      expect(find.text(expectedValue.toString()), findsOneWidget);
      expect(result, equals(expectedValue));
    });

    testWidgets('division - widget updates', (tester) async {
      const int expectedValue = 2;
      const int startingValue = 10;
      const int divisor = 5;

      viewModel.age(startingValue);

      await tester.pumpWidget(testWidget);

      expect(find.text(viewModel.age.toString()), findsOneWidget);

      final result = viewModel.age.divide(divisor);

      viewModel.age(result.toInt());

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

    test('increment - returns increment value', () {
      const int expected = 4;
      viewModel.age(3);
      final result = viewModel.age.increment();
      expect(result, equals(expected));
      expect(viewModel.age.value, equals(expected));
    });

    test('decrement - returns decremented value', () {
      const int expected = 2;
      viewModel.age(3);
      final result = viewModel.age.decrement();
      expect(result, equals(expected));
      expect(viewModel.age.value, equals(expected));
    });

    test('add - other is int - returns correct int value', () {
      const expected = 2;
      final number = EmpireIntProperty(1);
      final result = number.add(1);

      expect(result, equals(expected));
    });

    test('add - other is double - returns correct double value', () {
      const expected = 2.5;
      final number = EmpireIntProperty(1);
      final result = number.add(1.5);

      expect(result, equals(expected));
    });

    test('subtract - other is int - returns correct int value', () {
      const expected = 2;
      final number = EmpireIntProperty(3);
      final result = number.subtract(1);

      expect(result, equals(expected));
    });

    test('subtract - other is double - returns correct double value', () {
      const expected = 2.5;
      final number = EmpireIntProperty(4);
      final result = number.subtract(1.5);

      expect(result, equals(expected));
    });

    test('multiply - other is int - returns correct int value', () {
      const expected = 4;
      final number = EmpireIntProperty(2);
      final result = number.multiply(2);

      expect(result, equals(expected));
    });

    test('multiply - other is double - returns correct double value', () {
      const expected = 5.4;
      final number = EmpireIntProperty(2);
      final result = number.multiply(2.7);

      expect(result, equals(expected));
    });

    test('divide - returns correct double value', () {
      const expected = 4.0;
      final number = EmpireIntProperty(8);
      final result = number.divide(2);

      expect(result, equals(expected));
    });

    test('mod - other is int - returns correct int value', () {
      const expected = 2;
      final number = EmpireIntProperty(5);
      final result = number.mod(3);

      expect(result, equals(expected));
    });

    test('mod - other is double - returns correct double value', () {
      const expected = 1.5;
      final number = EmpireIntProperty(5);
      final result = number.mod(3.5);

      expect(result, equals(expected));
    });
  });
}
