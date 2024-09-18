import 'package:empire/empire.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

class MapViewModel extends EmpireViewModel {
  final data = EmpireMapProperty<String, String>.empty();

  @override
  Iterable<EmpireProperty> get empireProps => [data];
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

void main() {
  group('EmpireMapProperty Tests', () {
    late MapViewModel viewModel;
    late MapTestWidget testWidget;
    setUp(() {
      viewModel = MapViewModel();
      testWidget = MapTestWidget(viewModel: viewModel);
    });

    testWidgets('add - widget updates', (tester) async {
      const String expectedKey = 'name';
      const String expectedValue = 'Bob';

      await tester.pumpWidget(testWidget);

      expect(find.text(expectedKey), findsNothing);
      expect(find.text(expectedValue), findsNothing);

      viewModel.data.add(expectedKey, expectedValue);

      await tester.pumpAndSettle();

      expect(find.text(expectedKey), findsOneWidget);
      expect(find.text(expectedValue), findsOneWidget);
    });

    testWidgets('addEntry - widget updates', (tester) async {
      const String expectedKey = 'name';
      const String expectedValue = 'Bob';

      await tester.pumpWidget(testWidget);

      expect(find.text(expectedKey), findsNothing);
      expect(find.text(expectedValue), findsNothing);

      viewModel.data.addEntry(const MapEntry(expectedKey, expectedValue));

      await tester.pumpAndSettle();

      expect(find.text(expectedKey), findsOneWidget);
      expect(find.text(expectedValue), findsOneWidget);
    });

    testWidgets('addEntries - widget updates', (tester) async {
      const String expectedKeyOne = 'firstName';
      const String expectedValueOne = 'Bob';
      const String expectedKeyTwo = 'lastName';
      const String expectedValueTwo = 'Smith';

      await tester.pumpWidget(testWidget);

      expect(find.text(expectedKeyOne), findsNothing);
      expect(find.text(expectedValueOne), findsNothing);
      expect(find.text(expectedKeyTwo), findsNothing);
      expect(find.text(expectedValueTwo), findsNothing);

      viewModel.data.addEntries([
        const MapEntry(expectedKeyOne, expectedValueOne),
        const MapEntry(expectedKeyTwo, expectedValueTwo)
      ]);

      await tester.pumpAndSettle();

      expect(find.text(expectedKeyOne), findsOneWidget);
      expect(find.text(expectedValueOne), findsOneWidget);
      expect(find.text(expectedKeyTwo), findsOneWidget);
      expect(find.text(expectedValueTwo), findsOneWidget);
    });

    testWidgets('addAll - widget updates', (tester) async {
      const String expectedKeyOne = 'firstName';
      const String expectedValueOne = 'Bob';
      const String expectedKeyTwo = 'lastName';
      const String expectedValueTwo = 'Smith';

      await tester.pumpWidget(testWidget);

      expect(find.text(expectedKeyOne), findsNothing);
      expect(find.text(expectedValueOne), findsNothing);
      expect(find.text(expectedKeyTwo), findsNothing);
      expect(find.text(expectedValueTwo), findsNothing);

      viewModel.data.addAll({
        expectedKeyOne: expectedValueOne,
        expectedKeyTwo: expectedValueTwo,
      });

      await tester.pumpAndSettle();

      expect(find.text(expectedKeyOne), findsOneWidget);
      expect(find.text(expectedValueOne), findsOneWidget);
      expect(find.text(expectedKeyTwo), findsOneWidget);
      expect(find.text(expectedValueTwo), findsOneWidget);
    });

    testWidgets('update - key is present - widget updates', (tester) async {
      const String keyOne = 'firstName';
      const String valueOne = 'Bob';
      const String keyTwo = 'lastName';
      const String valueTwo = 'Smith';
      const String expectedUpdatedValue = 'Doe';

      final Map<String, String> data = {
        keyOne: valueOne,
        keyTwo: valueTwo,
      };

      viewModel.data.addAll(data);

      await tester.pumpWidget(testWidget);

      viewModel.data.update(keyOne, (value) => value = expectedUpdatedValue);

      await tester.pumpAndSettle();

      expect(find.text(expectedUpdatedValue), findsOneWidget);
    });

    testWidgets('update - key is not preset - calls ifAbsent - widget updates',
        (tester) async {
      const String keyOne = 'firstName';

      const String expectedUpdatedValue = 'Doe';

      await tester.pumpWidget(testWidget);

      viewModel.data.update(
        keyOne,
        (value) => value = expectedUpdatedValue,
        ifAbsent: () => expectedUpdatedValue,
      );

      await tester.pumpAndSettle();

      expect(find.text(expectedUpdatedValue), findsOneWidget);
    });

    testWidgets('updateAll - updates all values - widget updates',
        (tester) async {
      const String keyOne = 'firstName';
      const String valueOne = 'bob';
      const String keyTwo = 'lastName';
      const String valueTwo = 'smith';
      const String expectedValueOne = 'BOB';
      const String expectedValueTwo = 'SMITH';

      final Map<String, String> data = {
        keyOne: valueOne,
        keyTwo: valueTwo,
      };

      viewModel.data.addAll(data);

      await tester.pumpWidget(testWidget);

      expect(find.text(expectedValueOne), findsNothing);
      expect(find.text(expectedValueTwo), findsNothing);

      viewModel.data.updateAll((key, value) => value.toUpperCase());

      await tester.pumpAndSettle();

      expect(find.text(expectedValueOne), findsOneWidget);
      expect(find.text(expectedValueTwo), findsOneWidget);
    });

    testWidgets('remove - key is present - item removed - widget updates',
        (tester) async {
      const String keyOne = 'firstName';
      const String valueOne = 'Bob';
      const String keyTwo = 'lastName';
      const String valueTwo = 'Smith';

      final Map<String, String> data = {
        keyOne: valueOne,
        keyTwo: valueTwo,
      };

      viewModel.data.addAll(data);

      await tester.pumpWidget(testWidget);

      expect(find.text(keyOne), findsOneWidget);
      expect(find.text(valueOne), findsOneWidget);
      expect(find.text(keyTwo), findsOneWidget);
      expect(find.text(valueTwo), findsOneWidget);

      viewModel.data.remove(keyTwo);

      await tester.pumpAndSettle();

      expect(find.text(keyOne), findsOneWidget);
      expect(find.text(valueOne), findsOneWidget);
      expect(find.text(keyTwo), findsNothing);
      expect(find.text(valueTwo), findsNothing);
    });

    testWidgets(
        'removeWhere - predicate finds match - item removed - widget updates',
        (tester) async {
      const String keyOne = 'firstName';
      const String valueOne = 'Bob';
      const String keyTwo = 'lastName';
      const String valueTwo = 'Smith';

      final Map<String, String> data = {
        keyOne: valueOne,
        keyTwo: valueTwo,
      };

      viewModel.data.addAll(data);

      await tester.pumpWidget(testWidget);

      expect(find.text(keyOne), findsOneWidget);
      expect(find.text(valueOne), findsOneWidget);
      expect(find.text(keyTwo), findsOneWidget);
      expect(find.text(valueTwo), findsOneWidget);

      viewModel.data.removeWhere((key, value) => value == valueTwo);

      await tester.pumpAndSettle();

      expect(find.text(keyOne), findsOneWidget);
      expect(find.text(valueOne), findsOneWidget);
      expect(find.text(keyTwo), findsNothing);
      expect(find.text(valueTwo), findsNothing);
    });

    testWidgets('clear - all items removed - widget updates', (tester) async {
      const String keyOne = 'firstName';
      const String valueOne = 'Bob';
      const String keyTwo = 'lastName';
      const String valueTwo = 'Smith';

      final Map<String, String> data = {
        keyOne: valueOne,
        keyTwo: valueTwo,
      };

      viewModel.data.addAll(data);

      await tester.pumpWidget(testWidget);

      expect(find.text(keyOne), findsOneWidget);
      expect(find.text(valueOne), findsOneWidget);
      expect(find.text(keyTwo), findsOneWidget);
      expect(find.text(valueTwo), findsOneWidget);

      viewModel.data.clear();

      await tester.pumpAndSettle();

      expect(find.text(keyOne), findsNothing);
      expect(find.text(valueOne), findsNothing);
      expect(find.text(keyTwo), findsNothing);
      expect(find.text(valueTwo), findsNothing);
    });

    test('containsKey - has matching key - returns true', () {
      const String key = 'name';
      const String value = 'Bob';

      viewModel.data.add(key, value);

      final result = viewModel.data.containsKey(key);

      expect(result, isTrue);
    });

    test('containsKey - has no matching key - returns false', () {
      const String key = 'name';
      const String value = 'Bob';
      const String missingKey = 'lastName';

      viewModel.data.add(key, value);

      final result = viewModel.data.containsKey(missingKey);

      expect(result, isFalse);
    });

    test('containsValue - has matching value - returns true', () {
      const String key = 'name';
      const String value = 'Bob';

      viewModel.data.add(key, value);

      final result = viewModel.data.containsValue(value);

      expect(result, isTrue);
    });

    test('containsValue - has no matching value - returns false', () {
      const String key = 'name';
      const String value = 'Bob';
      const String missingValue = 'Smith';

      viewModel.data.add(key, value);

      final result = viewModel.data.containsValue(missingValue);

      expect(result, isFalse);
    });

    test('[] operator - has matching key - returns value', () {
      const String key = 'name';
      const String value = 'Bob';

      viewModel.data.add(key, value);

      final result = viewModel.data[key];

      expect(result, equals(value));
    });

    test('[] operator - has no matching key - returns value', () {
      const String key = 'name';
      const String value = 'Bob';
      const String missingKey = 'lastName';

      viewModel.data.add(key, value);

      final result = viewModel.data[missingKey];

      expect(result, isNull);
    });
    test(
        'reset - starting map is empty - add item - should be empty after reset',
        () {
      final data = EmpireMapProperty<String, String>.empty();
      data.setViewModel(viewModel);
      data.add('name', 'Bob');

      expect(data.isNotEmpty, isTrue);

      data.reset();

      expect(data.isEmpty, isTrue);
    });

    test(
        'reset - starting map has data - add item - only original data after reset',
        () {
      const String key = 'firstName';
      const String value = 'Bob';
      const String tmpKey = 'lastName';
      const String tmpValue = 'Smith';

      final data = EmpireMapProperty<String, String>({key: value});
      data.setViewModel(viewModel);

      expect(data.containsKey(key), isTrue);
      expect(data.containsValue(value), isTrue);

      data.add(tmpKey, tmpValue);

      expect(data.containsKey(tmpKey), isTrue);
      expect(data.containsValue(tmpValue), isTrue);

      data.reset();

      expect(data.containsKey(tmpKey), isFalse);
      expect(data.containsValue(tmpValue), isFalse);
      expect(data.containsKey(key), isTrue);
      expect(data.containsValue(value), isTrue);
    });

    test('resetting retains original value', () {
      final data = EmpireMapProperty<String, String>.empty();
      data.setViewModel(viewModel);
      data.add('name', 'Bob');

      data.reset();

      expect(data.isEmpty, isTrue);

      data.add('name', 'Bob');

      expect(data.originalValue.isEmpty, isTrue);
    });
  });
}
