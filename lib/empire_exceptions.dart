///Base class for any Empire specific exception
abstract class EmpireException implements Exception {
  final StackTrace? stack;
  final String? propertyName;
  final Type type;

  EmpireException(this.stack, this.propertyName, this.type);
}

///Thrown when an not-null-safe action is performed on a Nullable Empire Property, and the underlying value
///was null.
///
///An example is performing an arithmetic operation on an [EmpireNullableIntProperty] when the int value
///was null
class EmpirePropertyNullValueException extends EmpireException {
  EmpirePropertyNullValueException(super.stack, super.propertyName, super.type);

  @override
  String toString() =>
      'EmpirePropertyNullValueException: The underlying value for ${propertyName ?? type} is null.\nStack: $stack';
}
