import 'package:empire/empire.dart';
import 'package:empire/src/empire_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestViewModel extends EmpireViewModel {
  final EmpireProperty<String?> name = EmpireProperty(null);
  final EmpireProperty<int> age = EmpireProperty(1);

  @override
  Iterable<EmpireProperty> get empireProps => [name, age];
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

  group('Property Creation Tests', () {
    test('createNullProperty - Value is Null', () {
      final age = EmpireProperty<int?>(null);
      expect(age.value, isNull);
    });

    test('createProperty - passed value equals property value', () {
      const expectedValue = 10;
      final age = EmpireProperty<int>(expectedValue);
      expect(age.value, equals(expectedValue));
    });

    test('createProperty - set optional property name', () {
      const expectedValue = 'age';
      final age = EmpireProperty<int>(10, propertyName: expectedValue);
      expect(age.propertyName, equals(expectedValue));
    });
  });

  group('EmpireProperty Equality Tests', () {
    test('equals - other is same value - are equal', () {
      final ageOne = EmpireProperty<int>(10);
      const int ageTwo = 10;

      expect(ageOne.equals(ageTwo), isTrue);
    });

    test('equals - other is different value - are not equal', () {
      final ageOne = EmpireProperty<int>(10);
      const int ageTwo = 5;

      expect(ageOne.equals(ageTwo), isFalse);
    });

    test('equals - other is EmpireProperty with same value - are equal', () {
      final ageOne = EmpireProperty<int>(10);
      final ageTwo = EmpireProperty<int>(10);

      expect(ageOne.equals(ageTwo), isTrue);
    });

    test(
        'equals - other is EmpireProperty with different value - are not equal',
        () {
      final ageOne = EmpireProperty<int>(10);
      final ageTwo = EmpireProperty<int>(5);

      expect(ageOne.equals(ageTwo), isFalse);
    });

    test('equals - other is EmpireProperty with same value - are equal', () {
      final ageOne = EmpireProperty<int>(10);
      const double ageTwo = 10.0;

      expect(ageOne.equals(ageTwo), isTrue);
    });

    test('equality - other is EmpireProperty with same value - are equal', () {
      final ageOne = EmpireProperty<int>(10);
      final ageTwo = EmpireProperty<int>(10);

      expect(ageOne == ageTwo, isTrue);
    });

    test(
        'equality - other is EmpireProperty with different value - are not equal',
        () {
      final ageOne = EmpireProperty<int>(10);
      final ageTwo = EmpireProperty<int>(5);

      expect(ageOne == ageTwo, isFalse);
    });

    test(
        'equality - other is same as EmpireProperty generic type argument with same value - are equal',
        () {
      final ageOne = EmpireProperty<int>(10);
      const int ageTwo = 10;

      // ignore: unrelated_type_equality_checks
      expect(ageOne == ageTwo, isTrue);
    });

    test(
        'equality - other is same as EmpireProperty generic type argument with different value - are not equal',
        () {
      final ageOne = EmpireProperty<int>(10);
      const int ageTwo = 5;

      // ignore: unrelated_type_equality_checks
      expect(ageOne == ageTwo, isFalse);
    });

    test(
        'equality - other is not EmpireProperty or generic type argument - are not equal',
        () {
      final ageOne = EmpireProperty<int>(10);
      const String name = 'Bob';

      // ignore: unrelated_type_equality_checks
      expect(ageOne == name, isFalse);
    });

    test('isNull - value is null - returns true', () {
      final nullName = EmpireProperty<String?>(null);
      expect(nullName.isNull, isTrue);
    });

    test('isNull - value is not null - returns false', () {
      final nullName = EmpireProperty<String>('Bob');
      expect(nullName.isNull, isFalse);
    });

    test('isNotNull - value is not null - returns true', () {
      final nullName = EmpireProperty<String>('Bob');
      expect(nullName.isNotNull, isTrue);
    });

    test('isNotNull - value is null - returns false', () {
      final nullName = EmpireProperty<String?>(null);
      expect(nullName.isNotNull, isFalse);
    });

    test(
        'set - property not assigned to viewModel - throws PropertyNotAssignedToEmpireViewModelException',
        () {
      final property = EmpireProperty<String?>(null);

      expect(() => property('Bob'),
          throwsA(isA<PropertyNotAssignedToEmpireViewModelException>()));
    });
  });

  group('Property Original Value Tests', () {
    test(
        'setOriginalToCurrent - update original value - reset sets value to updated original ',
        () {
      const String expectedValue = 'Bob';
      final name = EmpireProperty<String?>(null);
      name.setViewModel(viewModel);
      name(expectedValue);

      expect(name.value, equals(expectedValue));

      name.reset();

      expect(name.isNull, isTrue);

      name(expectedValue);
      name.setOriginalValueToCurrent();
      name.reset();

      expect(name.value, equals(expectedValue));
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

    testWidgets('reset - notifyChange is false - UI Does Not Update',
        (tester) async {
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
