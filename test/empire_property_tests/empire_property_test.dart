import 'package:empire/empire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'bool_test_widgets.dart';
import 'list_test_widgets.dart';
import 'map_test_widgets.dart';

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

  group('EmpireProperty Equality Tests', () {
    test('equals - other is same value - are equal', () {
      final EmpireProperty<int> ageOne = viewModel.createProperty(10);
      const int ageTwo = 10;

      expect(ageOne.equals(ageTwo), isTrue);
    });

    test('equals - other is different value - are not equal', () {
      final EmpireProperty<int> ageOne = viewModel.createProperty(10);
      const int ageTwo = 5;

      expect(ageOne.equals(ageTwo), isFalse);
    });

    test('equals - other is EmpireProperty with same value - are equal', () {
      final EmpireProperty<int> ageOne = viewModel.createProperty(10);
      final EmpireProperty<int> ageTwo = viewModel.createProperty(10);

      expect(ageOne.equals(ageTwo), isTrue);
    });

    test('equals - other is EmpireProperty with different value - are not equal', () {
      final EmpireProperty<int> ageOne = viewModel.createProperty(10);
      final EmpireProperty<int> ageTwo = viewModel.createProperty(5);

      expect(ageOne.equals(ageTwo), isFalse);
    });

    test('equals - other is EmpireProperty with same value - are equal', () {
      final EmpireProperty<int> ageOne = viewModel.createProperty(10);
      const double ageTwo = 10.0;

      expect(ageOne.equals(ageTwo), isTrue);
    });

    test('equality - other is EmpireProperty with same value - are equal', () {
      final EmpireProperty<int> ageOne = viewModel.createProperty(10);
      final EmpireProperty<int> ageTwo = viewModel.createProperty(10);

      expect(ageOne == ageTwo, isTrue);
    });

    test('equality - other is EmpireProperty with different value - are not equal', () {
      final EmpireProperty<int> ageOne = viewModel.createProperty(10);
      final EmpireProperty<int> ageTwo = viewModel.createProperty(5);

      expect(ageOne == ageTwo, isFalse);
    });

    test('equality - other is same as EmpireProperty generic type argument with same value - are equal', () {
      final EmpireProperty<int> ageOne = viewModel.createProperty(10);
      const int ageTwo = 10;

      // ignore: unrelated_type_equality_checks
      expect(ageOne == ageTwo, isTrue);
    });

    test(
        'equality - other is same as EmpireProperty generic type argument with different value - are not equal',
        () {
      final EmpireProperty<int> ageOne = viewModel.createProperty(10);
      const int ageTwo = 5;

      // ignore: unrelated_type_equality_checks
      expect(ageOne == ageTwo, isFalse);
    });

    test('equality - other is not EmpireProperty or generic type argument - are not equal', () {
      final EmpireProperty<int> ageOne = viewModel.createProperty(10);
      const String name = 'Bob';

      // ignore: unrelated_type_equality_checks
      expect(ageOne == name, isFalse);
    });
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

  group('EmpireBoolProperty Tests', () {
    late BoolViewModel viewModel;
    late BoolTestWidget testWidget;
    setUp(() {
      viewModel = BoolViewModel();
      testWidget = BoolTestWidget(viewModel: viewModel);
    });

    testWidgets('bool value changes - widget updates', (tester) async {
      await tester.pumpWidget(testWidget);

      expect(find.text("true"), findsOneWidget);

      viewModel.isAwesome(false);

      await tester.pumpAndSettle();

      expect(find.text("false"), findsOneWidget);
    });

    test('isTrue - value is true - returns true', () {
      viewModel.isAwesome(true);
      expect(viewModel.isAwesome.isTrue, isTrue);
    });

    test('isTrue - value is false - returns false', () {
      viewModel.isAwesome(false);
      expect(viewModel.isAwesome.isTrue, isFalse);
    });

    test('isFalse - value is false - returns true', () {
      viewModel.isAwesome(false);
      expect(viewModel.isAwesome.isFalse, isTrue);
    });

    test('isFalse - value is true - returns false', () {
      viewModel.isAwesome(true);
      expect(viewModel.isAwesome.isFalse, isFalse);
    });
  });

  group('EmpireNullableBoolProperty Tests', () {
    late NullableBoolViewModel viewModel;

    setUp(() {
      viewModel = NullableBoolViewModel();
    });

    test('isTrue - value is true - returns true', () {
      viewModel.isAwesome(true);
      expect(viewModel.isAwesome.isTrue, isTrue);
    });

    test('isTrue - value is false - returns false', () {
      viewModel.isAwesome(false);
      expect(viewModel.isAwesome.isTrue, isFalse);
    });

    test('isTrue - value is null - returns false', () {
      viewModel.isAwesome(null);
      expect(viewModel.isAwesome.isTrue, isFalse);
    });

    test('isFalse - value is false - returns true', () {
      viewModel.isAwesome(false);
      expect(viewModel.isAwesome.isFalse, isTrue);
    });

    test('isFalse - value is true - returns false', () {
      viewModel.isAwesome(true);
      expect(viewModel.isAwesome.isFalse, isFalse);
    });

    test('isFalse - value is null - returns false', () {
      viewModel.isAwesome(null);
      expect(viewModel.isAwesome.isFalse, isFalse);
    });
  });

  group('EmpireListProperty Tests', () {
    late ListViewModel viewModel;
    late ListTestWidget testWidget;
    setUp(() {
      viewModel = ListViewModel();
      testWidget = ListTestWidget(viewModel: viewModel);
    });

    testWidgets('item added - widget updates', (tester) async {
      String earth = 'Earth';

      await tester.pumpWidget(testWidget);

      expect(find.text(earth), findsNothing);

      viewModel.planets.add(earth);

      await tester.pumpAndSettle();

      expect(find.text(earth), findsOneWidget);
    });

    testWidgets('multiple items added - widget updates', (tester) async {
      String earth = 'Earth';
      String venus = 'Venus';

      await tester.pumpWidget(testWidget);

      expect(find.text(earth), findsNothing);
      expect(find.text(venus), findsNothing);

      viewModel.planets.addAll([earth, venus]);

      await tester.pumpAndSettle();

      expect(find.text(earth), findsOneWidget);
      expect(find.text(venus), findsOneWidget);
    });

    testWidgets('remove item - widget updates', (tester) async {
      String earth = 'Earth';
      viewModel.planets.add(earth);

      await tester.pumpWidget(testWidget);

      expect(find.text(earth), findsOneWidget);

      viewModel.planets.remove(earth);

      await tester.pumpAndSettle();

      expect(find.text(earth), findsNothing);
    });

    testWidgets('removeAt - widget updates', (tester) async {
      String earth = 'Earth';
      String venus = 'Venus';

      viewModel.planets.addAll([earth, venus]);

      await tester.pumpWidget(testWidget);

      expect(find.text(earth), findsOneWidget);
      expect(find.text(venus), findsOneWidget);

      viewModel.planets.removeAt(1);

      await tester.pumpAndSettle();

      expect(find.text(earth), findsOneWidget);
      expect(find.text(venus), findsNothing);
    });

    testWidgets('clear - widget updates', (tester) async {
      String earth = 'Earth';
      String venus = 'Venus';

      viewModel.planets.addAll([earth, venus]);

      await tester.pumpWidget(testWidget);

      expect(find.text(earth), findsOneWidget);
      expect(find.text(venus), findsOneWidget);

      viewModel.planets.clear();

      await tester.pumpAndSettle();

      expect(find.text(earth), findsNothing);
      expect(find.text(venus), findsNothing);
    });

    test('contains - contains item - returns true', () {
      String earth = 'Earth';
      viewModel.planets.add(earth);
      final result = viewModel.planets.contains(earth);
      expect(result, isTrue);
    });

    test('contains - does not contain item - returns true', () {
      String earth = 'Earth';
      String venus = 'Venus';

      viewModel.planets.add(earth);

      final result = viewModel.planets.contains(venus);

      expect(result, isFalse);
    });

    test('indexOf - list contains item - returns correct index', () {
      String earth = 'Earth';
      const int expectedIndex = 0;

      viewModel.planets.add(earth);

      final result = viewModel.planets.indexOf(earth);

      expect(result, equals(expectedIndex));
    });

    test('[] operator - pass valid index value - returns correct value', () {
      String earth = 'Earth';

      viewModel.planets.add(earth);

      final result = viewModel.planets[0];

      expect(result, equals(earth));
    });

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

      testWidgets('update - key is not preset - calls ifAbsent - widget updates', (tester) async {
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

      testWidgets('updateAll - updates all values - widget updates', (tester) async {
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

      testWidgets('remove - key is present - item removed - widget updates', (tester) async {
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

      testWidgets('removeWhere - predicate finds match - item removed - widget updates', (tester) async {
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
    });
  });
}
