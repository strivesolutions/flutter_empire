import 'package:empire/empire_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestViewModel extends EmpireViewModel {
  late EmpireProperty<String?> name;
  late EmpireProperty<int> age;

  @override
  void initProperties() {
    name = createNullProperty();
    age = createProperty(1);
  }

  void useSetMultiple(String name, int age) {
    setMultiple({
      this.name: name,
      this.age: age,
    });
  }
}

void main() {
  group('SetMultiple Tests', () {
    test('createNullProperty - Value is Null', () {
      final viewModel = _TestViewModel();
      final EmpireProperty<int?> age = viewModel.createNullProperty();
      expect(age.value, isNull);
    });

    test('createProperty - passed value equals property value', () {
      final viewModel = _TestViewModel();
      const expectedValue = 10;
      final EmpireProperty<int> age = viewModel.createProperty(expectedValue);
      expect(age.value, equals(expectedValue));
    });

    test('createProperty - set optional property name', () {
      final viewModel = _TestViewModel();
      const expectedValue = 'age';
      final EmpireProperty<int> age = viewModel.createProperty(10, propertyName: expectedValue);
      expect(age.propertyName, equals(expectedValue));
    });
  });
}
