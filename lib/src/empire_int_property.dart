part of 'empire_property.dart';

///An [EmpireProperty] with similar characteristics of dart [int] objects
///
///The underlying value cannot be null. For a nullable int empire property,
///use the [EmpireNullableIntProperty].
///
///You can perform most arithmetic operator on this (+, -, /, *).
///
///Unary operators are not supported (++, --, +=, -=, etc)
///
///When the value of this changes, it will send a [EmpireStateChanged] event by default. This includes
///automatically triggering a UI rebuild.
///
///Example
///```dart
///
///late final EmpireIntProperty age;
///
///age = createIntProperty(10);
///
///print('${age + 5}'); //prints 15
///```
class EmpireIntProperty extends EmpireProperty<int> {
  EmpireIntProperty(super.value, {super.propertyName});

  /// Returns true if the int value is odd
  bool get isOdd => _value.isOdd;

  /// Returns true if the int value is even.
  bool get isEven => _value.isEven;

  /// Whether this number is negative.
  bool get isNegative => _value.isNegative;

  /// The int value as a double
  double toDouble() => _value.toDouble();

  /// Returns the absolute value of this integer.
  int abs() => _value.abs();

  int operator +(other) => (value + other).toInt();

  int operator -(other) => (value - other).toInt();

  int operator /(other) => value ~/ other;

  int operator %(other) => (value % other).toInt();

  int operator *(other) => (value * other).toInt();
}

///An [EmpireProperty] with similar characteristics of dart [int] objects
///
///The underlying value *can* be null.
///
///You can perform most arithmetic operator on this (+, -, /, *).
///If the underlying value of this is null and an arithmetic operator is called on this,
///it will throw a [EmpirePropertyNullValueException].
///
///Unary operators are not supported (++, --, +=, -=, etc)
///
///You can easily check for null by accessing the [isNull] or [isNotNull] properties.
///
///When the value of this changes, it will send a [EmpireStateChanged] event by default. This includes
///automatically triggering a UI rebuild.
///
///Example
///```dart
///late final EmpireNullableIntProperty age;
///
///age = createNullableIntProperty();
///
///if (age.isNull)
///{
///   print("I'm Null");
///}
///```
///
///Other Usages Examples
///```dart
///
///late final EmpireNullableIntProperty age;
///
///age = createNullableIntProperty();
///
///print('${age + 5}'); //throws EmpireNullValueException because no value has been set yet.
///
///age(10)
///
///print('${age - 5}'); //prints 5
///
///```
///
class EmpireNullableIntProperty extends EmpireProperty<int?> {
  EmpireNullableIntProperty(super.value, {super.propertyName});

  /// Returns true if the int value is odd
  ///
  /// Returns false if the int value is null
  bool get isOdd => _value?.isOdd ?? false;

  /// Returns true if the int value is even.
  ///
  /// Returns false if the int value is null
  bool get isEven => _value?.isEven ?? false;

  /// Whether this number is negative.
  ///
  /// Returns false if the int value is null
  bool get isNegative => _value?.isNegative ?? false;

  /// The int value as a double
  ///
  /// Returns null if the int value is null
  double? toDouble() => _value?.toDouble();

  /// Returns the absolute value of this integer.
  ///
  /// Returns null if the int value is null
  int? abs() => _value?.abs();

  int operator +(other) => isNotNull
      ? (value! + other).toInt()
      : throw EmpirePropertyNullValueException(
          StackTrace.current, propertyName, runtimeType);

  int operator -(other) => isNotNull
      ? (value! - other).toInt()
      : throw EmpirePropertyNullValueException(
          StackTrace.current, propertyName, runtimeType);

  int operator /(other) => isNotNull
      ? value! ~/ other!
      : throw EmpirePropertyNullValueException(
          StackTrace.current, propertyName, runtimeType);

  int operator %(other) => isNotNull
      ? (value! % other).toInt()
      : throw EmpirePropertyNullValueException(
          StackTrace.current, propertyName, runtimeType);

  int operator *(other) => isNotNull
      ? (value! * other).toInt()
      : throw EmpirePropertyNullValueException(
          StackTrace.current, propertyName, runtimeType);
}

///Short hand helper function for initializing an [EmpireIntProperty].
///
///See [EmpireProperty] for [propertyName] usages.
///
///## Example
///
///```dart
///late final EmpireIntProperty age;
///
///age = createIntProperty(20);
///```
EmpireIntProperty createIntProperty(int value, {String? propertyName}) {
  return EmpireIntProperty(value, propertyName: propertyName);
}

///Short hand helper function for initializing an [EmpireNullableIntProperty].
///
///See [EmpireProperty] for [propertyName] usages.
///
///## Example
///
///```dart
///late final EmpireNullableIntProperty age;
///
///age = createNullableIntProperty();
///```
EmpireNullableIntProperty createNullableIntProperty(
    {int? value, String? propertyName}) {
  return EmpireNullableIntProperty(value, propertyName: propertyName);
}
