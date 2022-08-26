part of 'empire_property.dart';

///An [EmpireProperty] with similar characteristics as a dart [String] object
///
///When the value of this changes, it will send a [EmpireStateChanged] event by default. This includes
///automatically triggering a UI rebuild.
class EmpireStringProperty extends EmpireProperty<String> {
  EmpireStringProperty(super.value, {super.propertyName});

  ///Whether the string value is empty
  bool get isEmpty => _value.isEmpty;

  ///Whether the string value is empty or not
  bool get isNotEmpty => _value.isNotEmpty;

  /// The length of the string value.
  int get length => _value.length;

  /// Whether the string value contains a match of [other].
  ///
  /// Example:
  /// ```dart
  /// const string = 'Doug';
  /// final containsD = string.contains('D'); // true
  /// final containsUpperCase = string.contains(RegExp(r'[A-Z]')); // true
  /// ```
  /// If [startIndex] is provided, this method matches only at or after that
  /// index:
  /// ```dart
  /// const string = 'Doug smith';
  /// final containsD = string.contains(RegExp('D'), 0); // true
  /// final caseSensitive = string.contains(RegExp(r'[A-Z]'), 1); // false
  /// ```
  /// The [startIndex] must not be negative or greater than [length].
  bool contains(String other) => _value.contains(other);

  /// The substring of the string value from [start], inclusive, to [end], exclusive.
  ///
  /// Example:
  /// ```dart
  /// const string = 'dougsmith';
  /// var result = string.substring(1); // 'ougsmith'
  /// result = string.substring(1, 3); // 'oug'
  /// ```
  ///
  /// Both [start] and [end] must be non-negative and no greater than [length];
  /// [end], if provided, must be greater than or equal to [start].
  String substring(int start, [int? end]) => _value.substring(start, end);
}

///An [EmpireProperty] with similar characteristics as a dart [String] object
///
///The underlying value *can* be null.
///
///You can easily check for null by accessing the [isNull] or [isNotNull] properties.
///
///When the value of this changes, it will send a [EmpireStateChanged] event by default. This includes
///automatically triggering a UI rebuild.
class EmpireNullableStringProperty extends EmpireProperty<String?> {
  EmpireNullableStringProperty(super.value, {super.propertyName});

  ///Whether the string value is empty
  ///
  ///Returns true if the string value is null
  bool get isEmpty => _value?.isEmpty ?? true;

  ///Whether the string value is empty or not.
  ///
  ///Returns false if the string value is null
  bool get isNotEmpty => _value?.isNotEmpty ?? false;

  /// The length of the string value.
  ///
  /// Returns 0 if the string value is null
  int get length => _value?.length ?? 0;

  /// Whether the string value contains a match of [other].
  ///
  /// Returns false if the String value is null
  ///
  /// Example:
  /// ```dart
  /// const string = 'Doug';
  /// final containsD = string.contains('D'); // true
  /// final containsUpperCase = string.contains(RegExp(r'[A-Z]')); // true
  /// ```
  /// If [startIndex] is provided, this method matches only at or after that
  /// index:
  /// ```dart
  /// const string = 'Doug smith';
  /// final containsD = string.contains(RegExp('D'), 0); // true
  /// final caseSensitive = string.contains(RegExp(r'[A-Z]'), 1); // false
  /// ```
  /// The [startIndex] must not be negative or greater than [length].
  bool contains(String other) => _value?.contains(other) ?? false;

  /// The substring of the string value from [start], inclusive, to [end], exclusive.
  ///
  /// Returns null if the string value is null
  ///
  /// Example:
  /// ```dart
  /// const string = 'dougsmith';
  /// var result = string.substring(1); // 'ougsmith'
  /// result = string.substring(1, 3); // 'oug'
  /// ```
  ///
  /// Both [start] and [end] must be non-negative and no greater than [length];
  /// [end], if provided, must be greater than or equal to [start].
  String? substring(int start, [int? end]) => _value?.substring(start, end);
}

///Short hand helper function for initializing an [EmpireStringProperty].
///
///See [EmpireProperty] for [propertyName] usages.
///
///## Example
///
///```dart
///late final EmpireStringProperty name;
///
///name = createStringProperty('Bob');
///```
EmpireStringProperty createStringProperty(String value,
    {String? propertyName}) {
  return EmpireStringProperty(value, propertyName: propertyName);
}

///Short hand helper function for initializing an [EmpireNullableStringProperty].
///
///See [EmpireProperty] for [propertyName] usages.
///
///## Example
///
///```dart
///late final EmpireNullableStringProperty name;
///
///name = createNullableStringProperty();
///```
EmpireNullableStringProperty createNullableStringProperty(
    {String? value, String? propertyName}) {
  return EmpireNullableStringProperty(value, propertyName: propertyName);
}
