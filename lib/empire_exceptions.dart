abstract class EmpireException implements Exception {
  final StackTrace? stack;
  final String? propertyName;
  final Type type;

  EmpireException(this.stack, this.propertyName, this.type);
}

class EmpireNullValueException extends EmpireException {
  EmpireNullValueException(super.stack, super.propertyName, super.type);

  @override
  String toString() =>
      'EmpireNullValueException: The underlying value for ${propertyName ?? type} is null.\nStack: $stack';
}
