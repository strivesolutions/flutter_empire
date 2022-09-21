part of 'empire_property.dart';

///An [EmpireProperty] with similar characteristics of dart [double] objects
///
///The underlying value cannot be null. For a nullable double empire property,
///use the [EmpireNullableDoubleProperty].
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
///final percentage = EmpireDoubleProperty(10.0);
///
///print('${percentage + 5.2}'); //prints 15.2
///```
class EmpireDoubleProperty extends EmpireProperty<double> {
  EmpireDoubleProperty(super.value, {super.propertyName});

  ///Factory constructor for initializing an [EmpireDoubleProperty] to zero.
  ///
  ///See [EmpireProperty] for [propertyName] usages.
  ///
  ///## Example
  ///
  ///```dart
  ///final bankAccountBalance = EmpireDoubleProperty.zero();
  ///```
  factory EmpireDoubleProperty.zero({String? propertyName}) {
    return EmpireDoubleProperty(0, propertyName: propertyName);
  }

  /// Whether this number is negative.
  bool get isNegative => _value.isNegative;

  /// Truncates the double value and returns the int
  int toInt() => _value.toInt();

  /// Returns the integer closest to the double value.
  ///
  /// Rounds away from zero when there is no closest integer:
  ///  `(3.5).round() == 4` and `(-3.5).round() == -4`.
  ///
  /// Throws an [UnsupportedError] if this number is not finite
  /// (NaN or an infinity).
  /// ```dart
  /// final number = EmpireDoubleProperty(3.25);
  /// print(number.roundToDouble()); // 3
  ///
  /// number(3.5);
  /// print(number.roundToDouble()); // 4
  ///
  /// number(3.75);
  /// print(number.roundToDouble()); // 4
  /// ```
  int round() => _value.round();

  /// Returns the integer double value closest to the double value.
  ///
  /// Rounds away from zero when there is no closest integer:
  ///  `(3.5).roundToDouble() == 4` and `(-3.5).roundToDouble() == -4`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is not
  /// a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`,
  /// and `-0.0` is therefore considered closer to negative numbers than `0.0`.
  /// This means that for a value `d` in the range `-0.5 < d < 0.0`,
  /// the result is `-0.0`.
  /// ```dart
  /// final number = EmpireDoubleProperty(3.25);
  /// print(number.roundToDouble()); // 3.0
  ///
  /// number(3.5);
  /// print(number.roundToDouble()); // 4.0
  ///
  /// number(3.75);
  /// print(number.roundToDouble()); // 4.0
  /// ```
  double roundToDouble() => _value.roundToDouble();

  double operator +(other) => value + other;

  double operator -(other) => value - other;

  double operator /(other) => value / other;

  double operator %(other) => value % other;

  double operator *(other) => value * other;
}

///An [EmpireProperty] with similar characteristics of dart [double] objects
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
///final percentage = EmpireNullableDoubleProperty(10.0);
///
///if (percentage.isNull)
///{
///   print("I'm Null");
///}
///```
///
///Other Usages Examples
///```dart
///
///final percentage = EmpireNullableDoubleProperty();
///
///print('${percentage + 5.2}'); //throws EmpireNullValueException because no value has been set yet.
///
///percentage(10.0)
///
///print('${percentage - 0.5}'); //prints 9.5
///
///```
///
class EmpireNullableDoubleProperty extends EmpireProperty<double?> {
  EmpireNullableDoubleProperty({double? value, super.propertyName})
      : super(value);

  factory EmpireNullableDoubleProperty.zero({String? propertyName}) {
    return EmpireNullableDoubleProperty(value: 0, propertyName: propertyName);
  }

  /// Whether this number is negative.
  ///
  /// Returns false if the double value is null
  bool get isNegative => _value?.isNegative ?? false;

  /// Truncates the double value and returns the int
  ///
  /// Returns null if the double value is null
  int? toInt() => _value?.toInt();

  /// Returns the integer closest to the double value.
  ///
  /// Returns null if the double value is null
  ///
  /// Rounds away from zero when there is no closest integer:
  ///  `(3.5).round() == 4` and `(-3.5).round() == -4`.
  ///
  /// Throws an [UnsupportedError] if this number is not finite
  /// (NaN or an infinity).
  /// ```dart
  /// final number = EmpireDoubleProperty(3.25);
  /// print(number.round()); // 3
  ///
  /// number(3.5);
  /// print(number.round()); // 4
  ///
  /// number(3.75);
  /// print(number.round()); // 4
  /// ```
  int? round() => _value?.round();

  /// Returns the integer double value closest to the double value.
  ///
  /// Returns null if the double value is null
  ///
  /// Rounds away from zero when there is no closest integer:
  ///  `(3.5).roundToDouble() == 4` and `(-3.5).roundToDouble() == -4`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is not
  /// a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`,
  /// and `-0.0` is therefore considered closer to negative numbers than `0.0`.
  /// This means that for a value `d` in the range `-0.5 < d < 0.0`,
  /// the result is `-0.0`.
  /// ```dart
  /// final number = EmpireDoubleProperty(3.25);
  /// print(number.roundToDouble()); // 3.0
  ///
  /// number(3.5);
  /// print(number.roundToDouble()); // 4.0
  ///
  /// number(3.75);
  /// print(number.roundToDouble()); // 4.0
  /// ```
  double? roundToDouble() => _value?.roundToDouble();

  double operator +(other) => isNotNull
      ? value! + other!
      : throw EmpirePropertyNullValueException(
          StackTrace.current, propertyName, runtimeType);

  double operator -(other) => isNotNull
      ? value! - other!
      : throw EmpirePropertyNullValueException(
          StackTrace.current, propertyName, runtimeType);

  double operator /(other) => isNotNull
      ? value! / other!
      : throw EmpirePropertyNullValueException(
          StackTrace.current, propertyName, runtimeType);

  double operator %(other) => isNotNull
      ? value! % other!
      : throw EmpirePropertyNullValueException(
          StackTrace.current, propertyName, runtimeType);

  double operator *(other) => isNotNull
      ? value! * other!
      : throw EmpirePropertyNullValueException(
          StackTrace.current, propertyName, runtimeType);
}
