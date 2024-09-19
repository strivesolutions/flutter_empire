import 'package:empire/src/empire_exceptions.dart';
import 'package:empire/src/empire_cloneable.dart';

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
///will prevent the [reset] function from performing as expected.
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

  final bool isPrimitiveType;

  late T _originalValue;
  T get originalValue => _originalValue;

  T _value;

  @override
  T get value => _value;

  /// Returns true if the value of [this] is null.
  ///
  bool get isNull => _value == null;

  /// Returns true if the value of [this] is not null.
  bool get isNotNull => !isNull;

  EmpireViewModel? _viewModel;

  /// Returns the instance of the [EmpireViewModel] this
  /// property is associated with.
  ///
  EmpireViewModel get viewModel {
    if (_viewModel == null) {
      throw PropertyNotAssignedToEmpireViewModelException(
          StackTrace.current, propertyName, runtimeType);
    } else {
      return _viewModel!;
    }
  }

  EmpireProperty(
    this._value, {
    this.propertyName,
    this.isPrimitiveType = false,
  }) {
    _originalValue = _value;
  }

  ///Links this EmpireProperty instance with an [EmpireViewModel].
  ///
  void setViewModel(EmpireViewModel viewModel) {
    _viewModel = viewModel;
  }

  /// Updates the underlying [value] for this EmpireProperty.
  ///
  /// If [notifyChange] is true, a UI update will be triggered after the change occurs. Otherwise,
  /// only the value will be set.
  ///
  /// If [setAsOriginal] is true, updating the value will also set the [originalValue] to the
  /// current value. See also [setOriginalValueToCurrent] and [reset]
  ///
  void call(T value, {bool notifyChange = true, bool setAsOriginal = false}) {
    set(value, notifyChange: notifyChange, setAsOriginal: setAsOriginal);
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
  T set(T value, {bool notifyChange = true, bool setAsOriginal = false}) {
    final previousValue = _value;
    _value = value;
    if (notifyChange && previousValue != value) {
      viewModel.notifyChanges([
        EmpireStateChanged(value, previousValue, propertyName: propertyName)
      ]);
    }

    if (setAsOriginal) {
      _originalValue = _value;
    }

    return _value;
  }

  ///Resets the [value] to the [originalValue].
  ///
  ///If [T] is a class with properties, changing the properties directly on the object
  ///instead of updating this EmpireProperty with a new instance of [T] with the updated values will
  ///prevent [reset] from performing as expected. Tracking the original value is done by reference
  ///internally.
  ///
  ///If [T] is a reference type, calling [reset] will update the [value] to the [originalValue] by
  ///reference, causing unexpected behavior. To avoid this, T should implement [EmpireCloneable]
  ///so the [value] will be reset to a deep copy of the [originalValue].
  ///
  ///If [T] is a primitiveType, setting [isPrimitiveType] to true will cause the supress the warning.
  ///Consider using the typed EmpireProperty classes (eg: [EmpireIntProperty], [EmpireStringProperty])
  ///in place of the generic [EmpireProperty] class for primitives.
  ///
  ///## Usage
  ///
  ///```dart
  ///final age = EmpireProperty<int>(10); //age.value is 10
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

    if (_originalValue is EmpireCloneable) {
      _value = (_originalValue as EmpireCloneable).clone();
    } else if (isPrimitiveType) {
      _value = _originalValue;
    } else {
      // ignore: avoid_print
      print(
          '[Empire] WARNING: $T is not EmpireCloneable and not marked as a primitive type. Reset may result in unexpected behavior. See EmpireProperty.reset documentation for more information.');
      _value = _originalValue;
    }

    if (notifyChange) {
      viewModel.notifyChanges([
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
  ///final age = EmpireProperty<int>(10);
  ///
  ///age.equals(10); //returns true
  ///
  ///
  ///final ageTwo = EmpireProperty<int>(10);
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
  // ignore: non_nullable_equals_parameter
  bool operator ==(dynamic other) => equals(other);

  @override
  int get hashCode => _value.hashCode;
}

///Short hand helper function for initializing an [EmpireProperty].
///
///See [EmpireProperty] for [propertyName] usages.
///
///## Example
///
///```dart
///late final EmpireProperty<String> name;
///
///name = createProperty('Bob');
///```
EmpireProperty<T> createProperty<T>(T value, {String? propertyName}) {
  return EmpireProperty<T>(value, propertyName: propertyName);
}

///Short hand helper function for initializing an [EmpireProperty] with a null value.
///
///See [EmpireProperty] for [propertyName] usages.
///
///## Example
///
///```dart
///late final EmpireProperty<String?> name;
///
///name = createNullProperty();
///
///```
EmpireProperty<T?> createNullProperty<T>({String? propertyName}) {
  return createProperty(null, propertyName: propertyName);
}
