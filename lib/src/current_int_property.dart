part of 'current_property.dart';

/// An [CurrentProperty] with similar characteristics of dart [int] objects
///
/// The underlying value cannot be null. For a nullable int current property,
/// use the [CurrentNullableIntProperty].
///
///
/// When the value of this changes, it will send a [CurrentStateChanged] event by default. This includes
/// automatically triggering a UI rebuild.
///
/// Example
/// ```dart
///
/// final age = CurrentIntProperty(10);
///
/// print('${age.add(5)}'); //prints 15
/// ```
class CurrentIntProperty extends CurrentProperty<int> {
  CurrentIntProperty(super.value, {super.propertyName})
      : super(isPrimitiveType: true);

  /// Factory constructor for initializing an [CurrentIntProperty] to zero.
  ///
  /// See [CurrentProperty] for [propertyName] usages.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final numberOfFriends = CurrentIntProperty.zero();
  /// ```
  factory CurrentIntProperty.zero({String? propertyName}) {
    return CurrentIntProperty(0, propertyName: propertyName);
  }

  /// Returns true if the int value is odd
  bool get isOdd => _value.isOdd;

  /// Returns true if the int value is even.
  bool get isEven => _value.isEven;

  /// Whether this number is negative.
  bool get isNegative => _value.isNegative;

  /// The int value as a double
  double toDouble() => _value.toDouble();

  /// Increment the int value by 1
  int increment({bool notifyChange = true}) =>
      set(_value + 1, notifyChange: notifyChange);

  /// Decrement the int value by 1
  int decrement({bool notifyChange = true}) =>
      set(_value - 1, notifyChange: notifyChange);

  /// Returns the absolute value of this integer.
  int abs() => _value.abs();

  /// Adds [other] to this number.
  ///
  /// This does not set the value for this [CurrentIntProperty].
  ///
  /// The result is an [int], as described by [int.+],
  /// if both this number and [other] is an integer,
  /// otherwise the result is a [double].
  E add<E extends num>(E other) {
    return (_value + other) as E;
  }

  /// Subtracts [other] from this number.
  ///
  /// This does not set the value for this [CurrentIntProperty].
  ///
  /// The result is an [int], as described by [int.-],
  /// if both this number and [other] is an integer,
  /// otherwise the result is a [double].
  E subtract<E extends num>(E other) {
    return (_value - other) as E;
  }

  /// Divides this number by [other].
  ///
  /// This does not set the value for this [CurrentIntProperty].
  double divide<E extends num>(E other) {
    return _value / other;
  }

  /// Euclidean modulo of this number by [other].
  ///
  /// This does not set the value for this [CurrentIntProperty].
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
  /// The result is an [int], as described by [int.%],
  /// if both this number and [other] are integers,
  /// otherwise the result is a [double].
  ///
  /// Example:
  /// ```dart
  /// final number = CurrentIntProperty(5);
  /// print(number % 3); // 2
  /// ```
  E mod<E extends num>(E other) {
    return (_value % other) as E;
  }

  /// Multiplies this number by [other].
  ///
  /// This does not set the value for this [CurrentIntProperty].
  ///
  /// The result is an [int], as described by [int.*],
  /// if both this number and [other] are integers,
  /// otherwise the result is a [double].
  E multiply<E extends num>(E other) {
    return (_value * other) as E;
  }
}

/// An [CurrentProperty] with similar characteristics of dart [int] objects
///
/// The underlying value *can* be null.
///
/// If the underlying value of this is null and an arithmetic operator is called on this,
/// it will throw a [CurrentPropertyNullValueException].
///
/// You can easily check for null by accessing the [isNull] or [isNotNull] properties.
///
/// When the value of this changes, it will send a [CurrentStateChanged] event by default. This includes
/// automatically triggering a UI rebuild.
///
/// Example
/// ```dart
/// final age = CurrentNullableIntProperty();
///
/// if (age.isNull)
/// {
///   print("I'm Null");
/// }
/// ```
///
/// Other Usages Examples
/// ```dart
///
/// final age = CurrentNullableIntProperty();
///
/// print('${age.add(5)}'); //throws CurrentNullValueException because no value has been set yet.
///
/// age(10)
///
/// print('${age.subtract(5)}'); //prints 5
///
/// ```
///
class CurrentNullableIntProperty extends CurrentProperty<int?> {
  CurrentNullableIntProperty({int? value, super.propertyName})
      : super(value, isPrimitiveType: true);

  /// Factory constructor for initializing an [CurrentNullableIntProperty] to zero.
  ///
  /// See [CurrentProperty] for [propertyName] usages.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final numberOfFriends = CurrentNullableIntProperty.zero();
  /// ```
  factory CurrentNullableIntProperty.zero({String? propertyName}) {
    return CurrentNullableIntProperty(value: 0, propertyName: propertyName);
  }

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

  /// Adds [other] to this number.
  ///
  /// This does not set the value for this [CurrentNullableIntProperty].
  ///
  /// If the underlying value is `null` throws an [CurrentPropertyNullValueException].
  ///
  /// The result is an [int], as described by [int.+],
  /// if both this number and [other] is an integer,
  /// otherwise the result is a [double].
  E add<E extends num>(E other) {
    return isNotNull
        ? (_value! + other) as E
        : throw CurrentPropertyNullValueException(
            StackTrace.current, propertyName, runtimeType);
  }

  /// Subtracts [other] from this number.
  ///
  /// This does not set the value for this [CurrentNullableIntProperty].
  ///
  /// If the underlying value is `null` throws an [CurrentPropertyNullValueException].
  ///
  /// The result is an [int], as described by [int.-],
  /// if both this number and [other] is an integer,
  /// otherwise the result is a [double].
  E subtract<E extends num>(E other) {
    return isNotNull
        ? (_value! - other) as E
        : throw CurrentPropertyNullValueException(
            StackTrace.current, propertyName, runtimeType);
  }

  /// Divides this number by [other].
  ///
  /// This does not set the value for this [CurrentNullableIntProperty].
  ///
  /// If the underlying value is `null` throws an [CurrentPropertyNullValueException].
  double divide<E extends num>(E other) {
    return isNotNull
        ? _value! / other
        : throw CurrentPropertyNullValueException(
            StackTrace.current, propertyName, runtimeType);
  }

  /// Euclidean modulo of this number by [other].
  ///
  /// This does not set the value for this [CurrentNullableIntProperty].
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
  /// The result is an [int], as described by [int.%],
  /// if both this number and [other] are integers,
  /// otherwise the result is a [double].
  ///
  /// If the underlying value is `null` throws an [CurrentPropertyNullValueException].
  ///
  /// Example:
  /// ```dart
  /// final number = CurrentNullableIntProperty(5);
  /// print(number % 3); // 2
  /// ```
  E mod<E extends num>(E other) {
    return isNotNull
        ? (_value! % other) as E
        : throw CurrentPropertyNullValueException(
            StackTrace.current, propertyName, runtimeType);
  }

  /// Multiplies this number by [other].
  ///
  /// This does not set the value for this [CurrentNullableIntProperty].
  ///
  /// The result is an [int], as described by [int.*],
  /// if both this number and [other] are integers,
  /// otherwise the result is a [double].
  ///
  /// If the underlying value is `null` throws an [CurrentPropertyNullValueException].
  E multiply<E extends num>(E other) {
    return isNotNull
        ? (_value! * other) as E
        : throw CurrentPropertyNullValueException(
            StackTrace.current, propertyName, runtimeType);
  }
}
