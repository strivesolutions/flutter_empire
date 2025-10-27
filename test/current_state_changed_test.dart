import 'package:current/current.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrentStateChanged Extension Tests', () {
    test(
        'containsPropertyName - contains event matching property name - returns true',
        () {
      const String propertyName = 'name';
      final events = [
        CurrentStateChanged('Bob', null, propertyName: propertyName)
      ];

      final foundEvent = events.containsPropertyName(propertyName);

      expect(foundEvent, isTrue);
    });

    test(
        'containsPropertyName - does not contain event matching property name - returns false',
        () {
      const String propertyName = 'name';
      final events = <CurrentStateChanged<String>>[];

      final foundEvent = events.containsPropertyName(propertyName);

      expect(foundEvent, isFalse);
    });

    test(
        'firstForPropertyName - contains event matching property name - returns event',
        () {
      const String propertyName = 'name';
      final event =
          CurrentStateChanged('Bob', null, propertyName: propertyName);
      final events = [event];
      final result = events.firstForPropertyName(propertyName);

      expect(result, isNotNull);
      expect(result, equals(event));
    });

    test(
        'firstForPropertyName - does not contain event matching property name - returns null',
        () {
      const String propertyName = 'name';
      final events = <CurrentStateChanged<String>>[];
      final result = events.firstForPropertyName(propertyName);

      expect(result, isNull);
    });

    test(
        'nextValueFor - contains event matching property name - returns nextValue',
        () {
      const String nextValue = 'Bob';
      const String propertyName = 'name';
      final events = [
        CurrentStateChanged(nextValue, null, propertyName: propertyName)
      ];

      final result = events.nextValueFor(propertyName);
      expect(result, equals(nextValue));
    });

    test(
        'nextValueFor - does not contain event matching property name - returns nextValue',
        () {
      const String propertyName = 'name';
      final events = <CurrentStateChanged<String>>[];

      final result = events.nextValueFor(propertyName);
      expect(result, isNull);
    });

    test(
        'previousValueFor - contains event matching property name - returns previousValue',
        () {
      const String previousValue = 'Bob';
      const String propertyName = 'name';
      final events = [
        CurrentStateChanged(null, previousValue, propertyName: propertyName)
      ];

      final result = events.previousValueFor(propertyName);
      expect(result, equals(previousValue));
    });

    test(
        'previousValueFor - does not contain event matching property name - returns previousValue',
        () {
      const String propertyName = 'name';
      final events = <CurrentStateChanged<String>>[];

      final result = events.previousValueFor(propertyName);
      expect(result, isNull);
    });
  });
}
