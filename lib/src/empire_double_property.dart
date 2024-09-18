part of 'empire_property.dart';

/// An [EmpireProperty] with similar characteristics of dart [double] objects
///
/// The underlying value cannot be null. For a nullable double empire property,
/// use the [EmpireNullableDoubleProperty].
///
///
/// When the value of this changes, it will send a [EmpireStateChanged] event by default. This includes
/// automatically triggering a UI rebuild.
///
/// Example
/// ```dart
///
/// final percentage = EmpireDoubleProperty(10.0);
///
/// print('${percentage.add(5.2)}'); //prints 15.2
/// ```
class EmpireDoubleProperty extends EmpireProperty<double> {
  EmpireDoubleProperty(super.value, {super.propertyName})
      : super(isPrimitiveType: true);

  /// Factory constructor for initializing an [EmpireDoubleProperty] to zero.
  ///
  /// See [EmpireProperty] for [propertyName] usages.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final bankAccountBalance = EmpireDoubleProperty.zero();
  /// ```
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
  /// print(number.round()); // 3
  ///
  /// number(3.5);
  /// print(number.round()); // 4
  ///
  /// number(3.75);
  /// print(number.round()); // 4
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

  /// Adds [other] to this number.
  ///
  /// This does not set the value for this [EmpireDoubleProperty].
  ///
  /// The result is an [double], as described by [double.+]
  double add<E extends num>(E other) {
    return _value + other;
  }

  /// Subtracts [other] from this number.
  ///
  /// This does not set the value for this [EmpireDoubleProperty].
  ///
  /// The result is an [double], as described by [double.-]
  double subtract<E extends num>(E other) {
    return _value - other;
  }

  /// Divides this number by [other].
  ///
  /// This does not set the value for this [EmpireDoubleProperty].
  ///
  /// The result is an [double], as described by [double./]
  double divide<E extends num>(E other) {
    return _value / other;
  }

  /// Euclidean modulo of this number by [other].
  ///
  /// This does not set the value for this [EmpireDoubleProperty].
  ///
  /// Returns the remainder of the Euclidean division.
  /// The Euclidean division of two integers `a` and `b`
  /// yields two integers `q` and `r` such that
  /// `a == b * q + r` and `0 <= r < b.abs()`.
  ///
  /// The Euclidean division is only defined for integers, but can be easily
  /// extended to work with doubles. In that case, `q` is still an integer,
  /// but `r` may have a non-integer value that still satisfies `0 <= r < |b|`.
  ///
  /// The sign of the returned value `r` is always positive.
  ///
  ///
  /// The result is an [double], as described by [double.%]
  ///
  /// Example:
  /// ```dart
  /// final number = EmpireDoubleProperty(5.0);
  /// print(number % 3); // 2.0
  /// ```
  double mod<E extends num>(E other) {
    return _value % other;
  }

  /// Multiplies this number by [other].
  ///
  /// This does not set the value for this [EmpireDoubleProperty].
  ///
  /// The result is an [double], as described by [double.*]
  double multiply<E extends num>(E other) {
    return _value * other;
  }
}

/// An [EmpireProperty] with similar characteristics of dart [double] objects
///
/// The underlying value *can* be null.
///
/// If the underlying value of this is null and an arithmetic operator is called on this,
/// it will throw a [EmpirePropertyNullValueException].
///
/// You can easily check for null by accessing the [isNull] or [isNotNull] properties.
///
/// When the value of this changes, it will send a [EmpireStateChanged] event by default. This includes
/// automatically triggering a UI rebuild.
///
/// Example
/// ```dart
/// final percentage = EmpireNullableDoubleProperty(10.0);
///
/// if (percentage.isNull)
/// {
///    print("I'm Null");
/// }
/// ```
///
/// Other Usages Examples
/// ```dart
///
/// final percentage = EmpireNullableDoubleProperty();
///
/// print('${percentage.add(5.2)}'); //throws EmpireNullValueException because no value has been set yet.
///
/// percentage(10.0)
///
/// print('${percentage.subtract(0.5)}'); //prints 9.5
///
/// ```
///
class EmpireNullableDoubleProperty extends EmpireProperty<double?> {
  EmpireNullableDoubleProperty({double? value, super.propertyName})
      : super(value, isPrimitiveType: true);

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
  /// final number = EmpireNullableDoubleProperty(3.25);
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
  /// final number = EmpireNullableDoubleProperty(3.25);
  /// print(number.roundToDouble()); // 3.0
  ///
  /// number(3.5);
  /// print(number.roundToDouble()); // 4.0
  ///
  /// number(3.75);
  /// print(number.roundToDouble()); // 4.0
  /// ```
  double? roundToDouble() => _value?.roundToDouble();

  /// Adds [other] to this number.
  ///
  /// This does not set the value for this [EmpireNullableDoubleProperty].
  ///
  /// The result is an [double], as described by [double.+].
  /// If the underlying value is [null] throws an [EmpirePropertyNullValueException].
  double add<E extends num>(E other) {
    return isNotNull
        ? _value! + other
        : throw EmpirePropertyNullValueException(
            StackTrace.current, propertyName, runtimeType);
  }

  /// Subtracts [other] from this number.
  ///
  /// This does not set the value for this [EmpireNullableDoubleProperty].
  ///
  /// The result is an [double], as described by [double.-],
  /// If the underlying value is [null] throws an [EmpirePropertyNullValueException].
  double subtract<E extends num>(E other) {
    return isNotNull
        ? _value! - other
        : throw EmpirePropertyNullValueException(
            StackTrace.current, propertyName, runtimeType);
  }

  /// Divides this number by [other].
  ///
  /// This does not set the value for this [EmpireNullableDoubleProperty].
  ///
  /// The result is an [double], as described by [double./],
  ///
  /// If the underlying value is [null] throws an [EmpirePropertyNullValueException].
  double divide<E extends num>(E other) {
    return isNotNull
        ? _value! / other
        : throw EmpirePropertyNullValueException(
            StackTrace.current, propertyName, runtimeType);
  }

  /// Euclidean modulo of this number by [other].
  ///
  /// This does not set the value for this [EmpireNullableDoubleProperty].
  ///
  /// Returns the remainder of the Euclidean division.
  /// The Euclidean division of two integers `a` and `b`
  /// yields two integers `q` and `r` such that
  /// `a == b * q + r` and `0 <= r < b.abs()`.
  ///
  /// The Euclidean division is only defined for integers, but can be easily
  /// extended to work with doubles. In that case, `q` is still an integer,
  /// but `r` may have a non-integer value that still satisfies `0 <= r < |b|`.
  ///
  /// The sign of the returned value `r` is always positive.
  ///
  ///
  /// The result is an [double], as described by [double.%]
  ///
  /// If the underlying value is [null] throws an [EmpirePropertyNullValueException].
  ///
  /// Example:
  /// ```dart
  /// final number = EmpireNullableDoubleProperty(5);
  /// print(number % 3); // 2.0
  /// ```
  double mod<E extends num>(E other) {
    return isNotNull
        ? _value! % other
        : throw EmpirePropertyNullValueException(
            StackTrace.current, propertyName, runtimeType);
  }

  /// Multiplies this number by [other].
  ///
  /// This does not set the value for this [EmpireNullableDoubleProperty].
  ///
  /// The result is an [double], as described by [double.*],
  /// If the underlying value is [null] throws an [EmpirePropertyNullValueException].
  double multiply<E extends num>(E other) {
    return isNotNull
        ? _value! * other
        : throw EmpirePropertyNullValueException(
            StackTrace.current, propertyName, runtimeType);
  }
}
