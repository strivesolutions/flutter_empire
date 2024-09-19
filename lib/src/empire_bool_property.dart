part of 'empire_property.dart';

///An [EmpireProperty] with similar characteristics as a an
///ordinary dart bool object
///
///Then underlying bool value cannot be null
///
///When the value of this changes, it will send a [EmpireStateChanged] event by default. This includes
///automatically triggering a UI rebuild.
class EmpireBoolProperty extends EmpireProperty<bool> {
  EmpireBoolProperty(super.value, {super.propertyName})
      : super(isPrimitiveType: true);

  ///Whether the underlying value is true
  bool get isTrue => _value;

  ///Whether the underlying value is false
  bool get isFalse => !_value;

  ///Sets the value to true
  void setTrue({bool notifyChange = true}) =>
      super.set(true, notifyChange: notifyChange);

  ///Sets the value to false
  void setFalse({bool notifyChange = true}) =>
      super.set(false, notifyChange: notifyChange);
}

///An [EmpireProperty] with similar characteristics as a an
///ordinary dart bool object.
///
///Then underlying bool value *CAN* be null
///
///When the value of this changes, it will send a [EmpireStateChanged] event by default. This includes
///automatically triggering a UI rebuild.
class EmpireNullableBoolProperty extends EmpireProperty<bool?> {
  EmpireNullableBoolProperty({bool? value, super.propertyName})
      : super(value, isPrimitiveType: true);

  ///Whether the underlying value is not null and true
  bool get isTrue => isNotNull && _value == true;

  ///Whether the underlying value is not null and false
  bool get isFalse => isNotNull && _value == false;

  ///Sets the value to true
  void setTrue({bool notifyChange = true}) =>
      super.set(true, notifyChange: notifyChange);

  ///Sets the value to false
  void setFalse({bool notifyChange = true}) =>
      super.set(false, notifyChange: notifyChange);

  ///Sets the value to null
  void setNull({bool notifyChange = true}) =>
      super.set(null, notifyChange: notifyChange);
}
