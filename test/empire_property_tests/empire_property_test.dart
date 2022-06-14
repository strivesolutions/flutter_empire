import 'package:empire/empire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'bool_test_widgets.dart';
import 'list_test_widgets.dart';

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
  });
}
