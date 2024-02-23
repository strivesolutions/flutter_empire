///Base class for any Empire specific exception
abstract class EmpireException implements Exception {
  final StackTrace? stack;
  final Type type;

  EmpireException(this.stack, this.type);
}

abstract class EmpirePropertyException extends EmpireException {
  final String? propertyName;

  EmpirePropertyException(super.stack, this.propertyName, super.type);
}

///Thrown when an not-null-safe action is performed on a Nullable Empire Property, and the underlying value
///was null.
///
///An example is performing an arithmetic operation on an [EmpireNullableIntProperty] when the int value
///was null
class EmpirePropertyNullValueException extends EmpirePropertyException {
  EmpirePropertyNullValueException(super.stack, super.propertyName, super.type);

  @override
  String toString() =>
      'EmpirePropertyNullValueException: The underlying value for ${propertyName ?? type} is null.\nStack: $stack';
}

///Thrown when an EmpireProperty value is changed and attempts to update the UI, but has not been added to the
///empireProps property of the associated EmpireViewModel
///
class PropertyNotAssignedToEmpireViewModelException
    extends EmpirePropertyException {
  PropertyNotAssignedToEmpireViewModelException(
      super.stack, super.propertyName, super.type);

  @override
  String toString() =>
      'PropertyNotAssignedToEmpireViewModelException: The value for ${propertyName ?? type} changed and failed to update the UI. Did you forget to add it to empireProps?.\nStack: $stack';
}

class EmpireViewModelAlreadyAssignedException extends EmpireException {
  EmpireViewModelAlreadyAssignedException(super.stack, super.type);

  @override
  String toString() =>
      'EmpireViewModelAlreadyAssignedException: The View Model of type $type has already been assigned to a different EmpireWidget.\nStack: $stack';
}
