import 'package:empire/empire_exceptions.dart';

import 'empire_view_model.dart';

part 'empire_bool_property.dart';
part 'empire_int_property.dart';
part 'empire_double_property.dart';
part 'empire_string_property.dart';
part 'empire_map_property.dart';
part 'empire_list_property.dart';
part 'empire_date_time_property.dart';

///Base class for [EmpireProperty]
abstract class EmpireValue<T> {
  T? get value;
}

///Contains any object that will notify any listeners when its value is changed.
///
///Usually these are properties that are bound to a UI Widget so when the value changes, the UI is updated.
///
///You optionally set the [propertyName] argument to conditionally perform logic when a specific
///property changes. You can access the [propertyName] in any event listener registered with the
///[EmpireViewModel.addOnStateChangedListener] function via the [propertyName] property on an [EmpireStateChanged] object.
///
///If [T] is of type [List] or [Map], use either [EmpireListProperty] or [EmpireMapProperty]. Not doing so
///will prevet the [reset] function from performing as expected.
///
///An [EmpireProperty] is callable. Calling the property updates the value. However, there are two
///ways to update the value of an [EmpireProperty]:
///
///*Using [set]*:
///```dart
/////initialize the property value to zero.
///final age = createProperty<int>(0);
///
/////update the property value to five.
///age.set(5);
///```
///
///-----------------------------------------
///
///*Calling the property*:
///```dart
/////initialize the property value to zero.
///final age = createProperty<int>(0);
///
/////update the property value to five.
///age(5);
///```
class EmpireProperty<T> implements EmpireValue<T> {
  String? propertyName;

  late T _originalValue;
  T get originalValue => _originalValue;

  T _value;

  @override
  T get value => _value;

  bool get isNull => _value == null;

  bool get isNotNull => !isNull;

  final EmpireViewModel _viewModel;

  EmpireProperty(this._value, this._viewModel, {this.propertyName}) {
    _originalValue = _value;
  }

  void call(T value, {bool notifyChange = true}) {
    set(value, notifyChange: notifyChange);
  }

  ///Updates the original value to what the current value of this property is.
  ///
  ///If this function is called, the [reset] function will then use the updated
  ///original value to set the current value
  ///
  ///## Example
  ///```dart
  ///final user = createNullProperty<User>();
  ///
  ///user(await userService.loadUser());
  ///
  ///user.reset(); //user value would be reset to null
  ///
  ///user(await userService.loadUser());
  ///
  ///user.setOriginalValueToCurrent();
  ///
  ///user(null);
  ///
  ///user.reset(); //user value would be reset to the user returned from the userService
  ///
  ///```
  void setOriginalValueToCurrent() {
    _originalValue = _value;
  }

  ///Updates the property value. Notifies any listeners to the change
  ///
  ///Returns the updated value
  T set(T value, {bool notifyChange = true}) {
    final previousValue = _value;
    _value = value;
    if (notifyChange && previousValue != value) {
      _viewModel.notifyChanges([
        EmpireStateChanged(value, previousValue, propertyName: propertyName)
      ]);
    }
    return _value;
  }

  ///Resets the value to what it was initialized with.
  ///
  ///If [T] is a  class with properties, changing the properties directly on the object
  ///instead of updating this EmpireProperty with a new instance of [T] with the updated values will
  ///prevent [reset] from performing as expected. Tracking the original value is done by reference
  ///internally.
  ///
  ///## Usage
  ///
  ///```dart
  ///late final EmpireProperty<int> age = createProperty(10); //age.value is 10
  ///
  ///age(20); //age.value is 20
  ///age(25); //age.value is 25
  ///
  ///age.reset(); //age.value is back to 10. Triggers UI rebuild or...
  ///
  ///age.reset(notifyChange: false); //age.value is back to 10 but UI does not rebuild
  ///```
  void reset({bool notifyChange = true}) {
    final currentValue = _value;
    _value = _originalValue;

    if (notifyChange) {
      _viewModel.notifyChanges([
        EmpireStateChanged(
          _originalValue,
          currentValue,
          propertyName: propertyName,
        )
      ]);
    }
  }

  @override
  String toString() => _value?.toString() ?? '';

  ///Checks if [other] is equal to the [value] of this EmpireProperty
  ///
  ///### Usage
  ///
  ///```dart
  ///final EmpireProperty<int> age = createProperty(10);
  ///
  ///age.equals(10); //returns true
  ///
  ///
  ///final EmpireProperty<int> ageTwo = createProperty(10);
  ///
  ///age.equals(ageTwo); //returns true
  ///```
  bool equals(dynamic other) {
    if (other is EmpireProperty) {
      return other.value == value;
    } else {
      return other == value;
    }
  }

  @override
  bool operator ==(dynamic other) => equals(other);

  @override
  int get hashCode => _value.hashCode;
}
