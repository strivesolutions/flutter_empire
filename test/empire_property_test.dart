import 'package:empire/empire.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestViewModel extends EmpireViewModel {
  @override
  void initProperties() {}
}

void main() {
  late _TestViewModel viewModel;
  setUp(() {
    viewModel = _TestViewModel();
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
}
