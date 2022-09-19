import 'package:empire/empire.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
}
