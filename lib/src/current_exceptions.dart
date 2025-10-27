///Base class for any Current specific exception
abstract class CurrentException implements Exception {
  final StackTrace? stack;
  final Type type;

  CurrentException(this.stack, this.type);
}

abstract class CurrentPropertyException extends CurrentException {
  final String? propertyName;

  CurrentPropertyException(super.stack, this.propertyName, super.type);
}

///Thrown when an not-null-safe action is performed on a Nullable Current Property, and the underlying value
///was null.
///
///An example is performing an arithmetic operation on an [CurrentNullableIntProperty] when the int value
///was null
class CurrentPropertyNullValueException extends CurrentPropertyException {
  CurrentPropertyNullValueException(
      super.stack, super.propertyName, super.type);

  @override
  String toString() =>
      'CurrentPropertyNullValueException: The underlying value for ${propertyName ?? type} is null.\nStack: $stack';
}

///Thrown when an CurrentProperty value is changed and attempts to update the UI, but has not been added to the
///currentProps property of the associated CurrentViewModel
///
class PropertyNotAssignedToCurrentViewModelException
    extends CurrentPropertyException {
  PropertyNotAssignedToCurrentViewModelException(
      super.stack, super.propertyName, super.type);

  @override
  String toString() =>
      'PropertyNotAssignedToCurrentViewModelException: The value for ${propertyName ?? type} changed and failed to update the UI. Did you forget to add it to currentProps?.\nStack: $stack';
}

class CurrentViewModelAlreadyAssignedException extends CurrentException {
  CurrentViewModelAlreadyAssignedException(super.stack, super.type);

  @override
  String toString() =>
      'CurrentViewModelAlreadyAssignedException: The View Model of type $type has already been assigned to a different CurrentWidget.\nStack: $stack';
}
