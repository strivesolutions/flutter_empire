import 'package:empire/empire_exceptions.dart';

import 'empire_view_model.dart';

///Base class for [EmpireProperty]
abstract class EmpireValue<T> {
  T? get value;
}

///Contains any object that will notify any listeners when its value is changed.
///
///Usually these are
///properties that are bound to a UI Widget so when the value changes, the UI is updated.
///
///You optionally set the [propertyName] argument to conditionally perform logic when a specific
///property changes. You can access the [propertyName] in any event listener registered with the
///[EmpireViewModel.addOnStateChangedListener] function via the [propertyName] property on an [EmpireStateChanged] object.
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
  T _value;
  late final T _originalValue;
  @override
  T get value => _value;

  final EmpireViewModel _viewModel;

  EmpireProperty(this._value, this._viewModel, {this.propertyName}) {
    _originalValue = _value;
  }

  void call(T value, {bool notifyChange = true}) {
    set(value, notifyChange: notifyChange);
  }

  ///Updates the property value. Notifies any listeners to the change
  ///
  ///Returns the updated value
  T set(T value, {bool notifyChange = true}) {
    final previousValue = _value;
    _value = value;
    if (notifyChange) {
      _viewModel.notifyChanges([EmpireStateChanged(value, previousValue, propertyName: propertyName)]);
    }
    return _value;
  }

  ///Resets the value to what it was initialized with.
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

abstract class NullableEmpireProperty<T> extends EmpireProperty<T?> {
  NullableEmpireProperty(super.value, super.viewModel, {super.propertyName});

  bool get isNull => _value == null;

  bool get isNotNull => _value != null;
}

class EmpireBoolProperty extends EmpireProperty<bool> {
  EmpireBoolProperty(super.value, super.viewModel, {super.propertyName});

  ///Whether the underlying value is true
  bool get isTrue => _value;

  ///Whether the underlying value is false
  bool get isFalse => !_value;
}

class EmpireNullableBoolProperty extends NullableEmpireProperty<bool?> {
  EmpireNullableBoolProperty(super.value, super.viewModel, {super.propertyName});

  ///Whether the underlying value is not null and true
  bool get isTrue => isNotNull && _value == true;

  ///Whether the underlying value is not null and false
  bool get isFalse => isNotNull && _value == false;
}

class EmpireListProperty<T> extends EmpireProperty<List<T>> {
  EmpireListProperty(super.value, super.viewModel, {super.propertyName});

  /// The number of objects in this list.
  ///
  /// The valid indices for a list are `0` through `length - 1`.
  /// ```dart
  /// final numbers = <int>[1, 2, 3];
  /// print(numbers.length); // 3
  /// ```
  int get length => _value.length;

  /// Adds [value] to the end of this list,
  /// extending the length by one.
  ///
  /// The list must be growable.
  ///
  /// ```dart
  /// final numbers = <int>[1, 2, 3];
  /// numbers.add(4);
  /// print(numbers); // [1, 2, 3, 4]
  /// ```
  void add(T value, {bool notifyChanges = true}) {
    _value.add(value);

    if (notifyChanges) {
      _viewModel.notifyChanges([EmpireStateChanged.addedToList(value)]);
    }
  }

  /// Appends all objects of [values] to the end of the list.
  ///
  /// Extends the length of the list by the number of objects in [values].
  /// The list must be growable.
  ///
  /// ```dart
  /// final numbers = <int>[1, 2, 3];
  /// numbers.addAll([4, 5, 6]);
  /// print(numbers); // [1, 2, 3, 4, 5, 6]
  /// ```
  void addAll(Iterable<T> values, {bool notifyChanges = true}) {
    _value.addAll(values);

    if (notifyChanges) {
      _viewModel.notifyChanges([EmpireStateChanged.addedAllToList(values)]);
    }
  }

  /// Removes the first occurrence of [value] from this list.
  ///
  /// Returns true if [value] was in the list, false otherwise.
  /// The list must be growable.
  ///
  /// ```dart
  /// final parts = <String>['head', 'shoulders', 'knees', 'toes'];
  /// final retVal = parts.remove('head'); // true
  /// print(parts); // [shoulders, knees, toes]
  /// ```
  /// The method has no effect if [value] was not in the list.
  /// ```dart
  /// final parts = <String>['shoulders', 'knees', 'toes'];
  /// // Note: 'head' has already been removed.
  /// final retVal = parts.remove('head'); // false
  /// print(parts); // [shoulders, knees, toes]
  /// ```
  bool remove(T value, {bool notifyChanges = true}) {
    final wasRemoved = _value.remove(value);

    if (notifyChanges && wasRemoved) {
      _viewModel.notifyChanges([EmpireStateChanged.removedFromList(value)]);
    }

    return wasRemoved;
  }

  /// Removes the object at position [index] from the list.
  ///
  /// This method reduces the length of `this` by one and moves all later objects
  /// down by one position.
  ///
  /// Returns the removed value.
  ///
  /// The [index] must be in the range `0 ≤ index < length`.
  /// The list must be growable.
  /// ```dart
  /// final parts = <String>['head', 'shoulder', 'knees', 'toes'];
  /// final retVal = parts.removeAt(2); // knees
  /// print(parts); // [head, shoulder, toes]
  /// ```
  T removeAt(int index, {bool notifyChanges = true}) {
    final removedValue = _value.removeAt(index);

    if (notifyChanges) {
      _viewModel.notifyChanges([EmpireStateChanged.removedFromList(removedValue)]);
    }

    return removedValue;
  }

  /// Removes all objects from this list; the length of the list becomes zero.
  ///
  /// The list must be growable.
  ///
  /// ```dart
  /// final numbers = <int>[1, 2, 3];
  /// numbers.clear();
  /// print(numbers.length); // 0
  /// print(numbers); // []
  /// ```
  void clear({bool notifyChanges = true}) {
    final stateChangedEvent = EmpireStateChanged.clearedList(_value, propertyName: propertyName);
    _value.clear();

    if (notifyChanges) {
      _viewModel.notifyChanges([stateChangedEvent]);
    }
  }

  /// Whether the collection contains an element equal to [value].
  ///
  /// This operation will check each element in order for being equal to
  /// [value], unless it has a more efficient way to find an element
  /// equal to [value].
  ///
  /// The equality used to determine whether [value] is equal to an element of
  /// the iterable defaults to the [Object.==] of the element.
  ///
  /// Some types of iterable may have a different equality used for its elements.
  /// For example, a [Set] may have a custom equality
  /// (see [Set.identity]) that its `contains` uses.
  /// Likewise the `Iterable` returned by a [Map.keys] call
  /// should use the same equality that the `Map` uses for keys.
  ///
  /// Example:
  /// ```dart
  /// final gasPlanets = <int, String>{1: 'Jupiter', 2: 'Saturn'};
  /// final containsOne = gasPlanets.keys.contains(1); // true
  /// final containsFive = gasPlanets.keys.contains(5); // false
  /// final containsJupiter = gasPlanets.values.contains('Jupiter'); // true
  /// final containsMercury = gasPlanets.values.contains('Mercury'); // false
  /// ```
  bool contains(T value) => _value.contains(value);

  /// The current elements of this iterable modified by [toElement].
  ///
  /// Returns a new lazy [Iterable] with elements that are created by
  /// calling `toElement` on each element of this `Iterable` in
  /// iteration order.
  ///
  /// The returned iterable is lazy, so it won't iterate the elements of
  /// this iterable until it is itself iterated, and then it will apply
  /// [toElement] to create one element at a time.
  /// The converted elements are not cached.
  /// Iterating multiple times over the returned [Iterable]
  /// will invoke the supplied [toElement] function once per element
  /// for on each iteration.
  ///
  /// Methods on the returned iterable are allowed to omit calling `toElement`
  /// on any element where the result isn't needed.
  /// For example, [elementAt] may call `toElement` only once.
  ///
  /// Equivalent to:
  /// ```
  /// Iterable<T> map<T>(T toElement(E e)) sync* {
  ///   for (var value in this) {
  ///     yield toElement(value);
  ///   }
  /// }
  /// ```
  /// Example:
  /// ```dart import:convert
  /// var products = jsonDecode('''
  /// [
  ///   {"name": "Screwdriver", "price": 42.00},
  ///   {"name": "Wingnut", "price": 0.50}
  /// ]
  /// ''');
  /// var values = products.map((product) => product['price'] as double);
  /// var totalPrice = values.fold(0.0, (a, b) => a + b); // 42.5.
  /// ```
  Iterable<T> map(T Function(T) toElement) {
    return _value.map(toElement);
  }

  /// Invokes [action] on each element of this iterable in iteration order.
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 6, 7];
  /// numbers.forEach(print);
  /// // 1
  /// // 2
  /// // 6
  /// // 7
  /// ```
  void forEach(void Function(T) action) {
    _value.forEach(action);
  }

  /// The first index of [value] in this list.
  ///
  /// Searches the list from index [start] to the end of the list.
  /// The first time an object `o` is encountered so that `o == element`,
  /// the index of `o` is returned.
  /// ```dart
  /// final notes = <String>['do', 're', 'mi', 're'];
  /// print(notes.indexOf('re')); // 1
  ///
  /// final indexWithStart = notes.indexOf('re', 2); // 3
  /// ```
  /// Returns -1 if [value] is not found.
  /// ```dart
  /// final notes = <String>['do', 're', 'mi', 're'];
  /// final index = notes.indexOf('fa'); // -1
  /// ```
  int indexOf(T value, [int start = 0]) => _value.indexOf(value, start);

  T operator [](int index) {
    return _value[index];
  }
}

class EmpireMapProperty<K, V> extends EmpireProperty<Map<K, V>> {
  EmpireMapProperty(super.value, super.viewModel, {super.propertyName});

  ///The map entries in the map
  Iterable<MapEntry<K, V>> get entries => _value.entries;

  /// Whether there is no key/value pair in the map.
  bool get isEmpty => _value.isEmpty;

  /// Whether there is at least one key/value pair in the map.
  bool get isNotEmpty => _value.isNotEmpty;

  /// The number of key/value pairs in the map.
  int get length => _value.length;

  /// The keys of the map.
  ///
  /// The returned iterable has efficient `length` and `contains` operations,
  /// based on [length] and [containsKey] of the map.
  ///
  /// The order of iteration is defined by the individual `Map` implementation,
  /// but must be consistent between changes to the map.
  ///
  /// Modifying the map while iterating the keys may break the iteration.
  Iterable<K> get keys => _value.keys;

  /// The values of the map.
  ///
  /// The values are iterated in the order of their corresponding keys.
  /// This means that iterating [keys] and [values] in parallel will
  /// provide matching pairs of keys and values.
  ///
  /// The returned iterable has a `length` method based on the
  /// [length] of the map. Its [Iterable.contains] method is based on
  /// `==` comparison.
  ///
  /// Modifying the map while iterating the values may break the iteration.
  Iterable<V> get values => _value.values;

  /// Adds all key/value pairs of [other] to this map.
  ///
  /// If a key of [other] is already in this map, its value is overwritten.
  void addAll(Map<K, V> other, {bool notifyChanges = true}) {
    _value.addAll(other);

    if (notifyChanges) {
      _viewModel.notifyChanges([EmpireStateChanged.addedMapToMap(other, propertyName: propertyName)]);
    }
  }

  /// Adds the key/value pair to this map.
  ///
  /// If the key of [entry] is already in this map,
  /// the corresponding value is overwritten.
  void addEntry(MapEntry<K, V> entry, {bool notifyChanges = true}) {
    _value.addEntries([entry]);

    if (notifyChanges) {
      _viewModel
          .notifyChanges([EmpireStateChanged.addedToMap(entry.key, entry.value, propertyName: propertyName)]);
    }
  }

  /// Adds all key/value pairs of [newEntries] to this map.
  ///
  /// If a key of [newEntries] is already in this map,
  /// the corresponding value is overwritten.
  ///
  /// The operation is equivalent to doing `this[entry.key] = entry.value`
  /// for each [MapEntry] of the iterable.
  /// ```dart
  /// final planets = <int, String>{1: 'Mercury', 2: 'Venus',
  ///   3: 'Earth', 4: 'Mars'};
  /// final gasGiants = <int, String>{5: 'Jupiter', 6: 'Saturn'};
  /// final iceGiants = <int, String>{7: 'Uranus', 8: 'Neptune'};
  /// planets.addEntries(gasGiants.entries);
  /// planets.addEntries(iceGiants.entries);
  /// print(planets);
  /// // {1: Mercury, 2: Venus, 3: Earth, 4: Mars, 5: Jupiter, 6: Saturn,
  /// //  7: Uranus, 8: Neptune}
  /// ```
  void addEntries(Iterable<MapEntry<K, V>> entries, {bool notifyChanges = true}) {
    _value.addEntries(entries);

    if (notifyChanges) {
      _viewModel.notifyChanges([EmpireStateChanged.addedEntriesToMap(entries, propertyName: propertyName)]);
    }
  }

  // Adds the [value] with the given [key] to the map.
  ///
  /// If the [key] is already in this map,
  /// the corresponding value is overwritten.
  void add(K key, V value, {bool notifyChanges = true}) {
    _value.addEntries([MapEntry<K, V>(key, value)]);

    if (notifyChanges) {
      _viewModel.notifyChanges([EmpireStateChanged.addedToMap(key, value, propertyName: propertyName)]);
    }
  }

  /// Updates the value for the provided [key].
  ///
  /// Returns the new value associated with the key.
  ///
  /// If the key is present, invokes [update] with the current value and stores
  /// the new value in the map.
  ///
  /// If the key is not present and [ifAbsent] is provided, calls [ifAbsent]
  /// and adds the key with the returned value to the map.
  ///
  /// If the key is not present, [ifAbsent] must be provided.
  /// ```dart
  /// final planetsFromSun = <int, String>{1: 'Mercury', 2: 'unknown',
  ///   3: 'Earth'};
  /// // Update value for known key value 2.
  /// planetsFromSun.update(2, (value) => 'Venus');
  /// print(planetsFromSun); // {1: Mercury, 2: Venus, 3: Earth}
  ///
  /// final largestPlanets = <int, String>{1: 'Jupiter', 2: 'Saturn',
  ///   3: 'Neptune'};
  /// // Key value 8 is missing from list, add it using [ifAbsent].
  /// largestPlanets.update(8, (value) => 'New', ifAbsent: () => 'Mercury');
  /// print(largestPlanets); // {1: Jupiter, 2: Saturn, 3: Neptune, 8: Mercury}
  /// ```
  V update(K key, V Function(V value) update, {V Function()? ifAbsent, bool notifyChanges = true}) {
    final originalValue = _value[key];
    final updatedValue = _value.update(key, update, ifAbsent: ifAbsent);

    if (notifyChanges) {
      _viewModel.notifyChanges([
        EmpireStateChanged.updateMapEntry(
          key,
          originalValue,
          updatedValue,
          propertyName: propertyName,
        )
      ]);
    }

    return updatedValue;
  }

  /// Updates all values.
  ///
  /// Iterates over all entries in the map and updates them with the result
  /// of invoking [update].
  /// ```dart
  /// final terrestrial = <int, String>{1: 'Mercury', 2: 'Venus', 3: 'Earth'};
  /// terrestrial.updateAll((key, value) => value.toUpperCase());
  /// print(terrestrial); // {1: MERCURY, 2: VENUS, 3: EARTH}
  /// ```
  void updateAll(V Function(K key, V value) update, {bool notifyChanges = true}) {
    final stateChangedEvents = <EmpireStateChanged<V>>[];

    _value.updateAll((key, value) {
      final previousValue = value;
      final updatedValue = update(key, value);
      stateChangedEvents.add(EmpireStateChanged.updateMapEntry(
        key,
        previousValue,
        updatedValue,
        propertyName: propertyName,
      ));
      return updatedValue;
    });

    if (notifyChanges) {
      _viewModel.notifyChanges(stateChangedEvents);
    }
  }

  /// Removes [key] and its associated value, if present, from the map.
  ///
  /// Returns the value associated with `key` before it was removed.
  /// Returns `null` if `key` was not in the map.
  ///
  /// Note that some maps allow `null` as a value,
  /// so a returned `null` value doesn't always mean that the key was absent.
  /// ```dart
  /// final terrestrial = <int, String>{1: 'Mercury', 2: 'Venus', 3: 'Earth'};
  /// final removedValue = terrestrial.remove(2); // Venus
  /// print(terrestrial); // {1: Mercury, 3: Earth}
  /// ```
  V? remove(K key, {bool notifyChanges = true}) {
    final removedValue = _value.remove(key);

    if (notifyChanges) {
      _viewModel.notifyChanges([
        EmpireStateChanged.removedFromMap(
          key,
          removedValue,
          propertyName: propertyName,
        )
      ]);
    }

    return removedValue;
  }

  /// Removes all entries of this map that satisfy the given [test].
  /// ```dart
  /// final terrestrial = <int, String>{1: 'Mercury', 2: 'Venus', 3: 'Earth'};
  /// terrestrial.removeWhere((key, value) => value.startsWith('E'));
  /// print(terrestrial); // {1: Mercury, 2: Venus}
  /// ```
  void removeWhere(bool Function(K key, V value) test, {bool notifyChanges = true}) {
    final stateChangedEvents = <EmpireStateChanged<V>>[];

    _value.removeWhere((key, value) {
      final shouldRemove = test(key, value);

      if (shouldRemove) {
        stateChangedEvents.add(EmpireStateChanged.removedFromMap(
          key,
          value,
          propertyName: propertyName,
        ));
      }

      return shouldRemove;
    });

    if (notifyChanges) {
      _viewModel.notifyChanges(stateChangedEvents);
    }
  }

  /// Removes all entries from the map.
  ///
  /// After this, the map is empty.
  /// ```dart
  /// final planets = <int, String>{1: 'Mercury', 2: 'Venus', 3: 'Earth'};
  /// planets.clear(); // {}
  /// ```
  void clear({bool notifyChanges = true}) {
    final stateChangedEvent = EmpireStateChanged(<K, V>{}, _value, propertyName: propertyName);

    _value.clear();

    if (notifyChanges) {
      _viewModel.notifyChanges([stateChangedEvent]);
    }
  }

  /// Whether this map contains the given [key].
  ///
  /// Returns true if any of the keys in the map are equal to `key`
  /// according to the equality used by the map.
  /// ```dart
  /// final moonCount = <String, int>{'Mercury': 0, 'Venus': 0, 'Earth': 1,
  ///   'Mars': 2, 'Jupiter': 79, 'Saturn': 82, 'Uranus': 27, 'Neptune': 14 };
  /// final containsUranus = moonCount.containsKey('Uranus'); // true
  /// final containsPluto = moonCount.containsKey('Pluto'); // false
  /// ```
  bool containsKey(K key) => _value.containsKey(key);

  /// Whether this map contains the given [value].
  ///
  /// Returns true if any of the values in the map are equal to `value`
  /// according to the `==` operator.
  /// ```dart
  /// final moonCount = <String, int>{'Mercury': 0, 'Venus': 0, 'Earth': 1,
  ///   'Mars': 2, 'Jupiter': 79, 'Saturn': 82, 'Uranus': 27, 'Neptune': 14 };
  /// final moons3 = moonCount.containsValue(3); // false
  /// final moons82 = moonCount.containsValue(82); // true
  /// ```
  bool containsValue(V value) => _value.containsValue(value);

  /// Returns a new map where all entries of this map are transformed by
  /// the given [convert] function.
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(dynamic, dynamic) convert) => _value.map(convert);

  /// Applies [action] to each key/value pair of the map.
  ///
  /// Calling `action` must not add or remove keys from the map.
  /// ```dart
  /// final planetsByMass = <num, String>{0.81: 'Venus', 1: 'Earth',
  ///   0.11: 'Mars', 17.15: 'Neptune'};
  ///
  /// planetsByMass.forEach((key, value) {
  ///   print('$key: $value');
  ///   // 0.81: Venus
  ///   // 1: Earth
  ///   // 0.11: Mars
  ///   // 17.15: Neptune
  /// });
  /// ```
  void forEach(void Function(dynamic, dynamic) action) => _value.forEach(action);

  V? operator [](K key) {
    return _value[key];
  }
}

class EmpireStringProperty extends EmpireProperty<String> {
  EmpireStringProperty(super.value, super.viewModel, {super.propertyName});

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

class EmpireNullableStringProperty extends NullableEmpireProperty<String?> {
  EmpireNullableStringProperty(super.value, super.viewModel, {super.propertyName});

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

class EmpireIntProperty extends EmpireProperty<int> {
  EmpireIntProperty(super.value, super.viewModel, {super.propertyName});

  /// Returns true if the int value is odd
  bool get isOdd => _value.isOdd;

  /// Returns true if the int value is even.
  bool get isEven => _value.isEven;

  /// Whether this number is negative.
  bool get isNegative => _value.isNegative;

  /// The int value as a double
  double toDouble() => _value.toDouble();

  /// Returns the absolute value of this integer.
  int abs() => _value.abs();

  int operator +(other) => set((value + other).toInt());

  int operator -(other) => set((value - other).toInt());

  int operator /(other) => set(value ~/ other);

  int operator %(other) => set((value % other).toInt());

  int operator *(other) => set((value * other).toInt());
}

class EmpireNullableIntProperty extends NullableEmpireProperty<int?> {
  EmpireNullableIntProperty(super.value, super.viewModel, {super.propertyName});

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

  int operator +(other) => isNotNull
      ? set((value! + other).toInt())!
      : throw EmpireNullValueException(StackTrace.current, propertyName, runtimeType);

  int operator -(other) => isNotNull
      ? set((value! - other).toInt())!
      : throw EmpireNullValueException(StackTrace.current, propertyName, runtimeType);

  int operator /(other) => isNotNull
      ? set(value! ~/ other)!
      : throw EmpireNullValueException(StackTrace.current, propertyName, runtimeType);

  int operator %(other) => isNotNull
      ? set((value! % other).toInt())!
      : throw EmpireNullValueException(StackTrace.current, propertyName, runtimeType);

  int operator *(other) => isNotNull
      ? set((value! * other).toInt())!
      : throw EmpireNullValueException(StackTrace.current, propertyName, runtimeType);
}

class EmpireDoubleProperty extends EmpireProperty<double> {
  EmpireDoubleProperty(super.value, super.viewModel, {super.propertyName});

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
  /// print(3.0.round()); // 3
  /// print(3.25.round()); // 3
  /// print(3.5.round()); // 4
  /// print(3.75.round()); // 4
  /// print((-3.5).round()); // -4
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
  /// print(3.0.roundToDouble()); // 3.0
  /// print(3.25.roundToDouble()); // 3.0
  /// print(3.5.roundToDouble()); // 4.0
  /// print(3.75.roundToDouble()); // 4.0
  /// print((-3.5).roundToDouble()); // -4.0
  /// ```
  double roundToDouble() => _value.roundToDouble();

  double operator +(other) => set(value + other);

  double operator -(other) => set(value - other);

  double operator /(other) => set(value / other);

  double operator %(other) => set(value % other);

  double operator *(other) => set(value * other);
}

class EmpireNullableDoubleProperty extends NullableEmpireProperty<double?> {
  EmpireNullableDoubleProperty(super.value, super.viewModel, {super.propertyName});

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
  /// print(3.0.round()); // 3
  /// print(3.25.round()); // 3
  /// print(3.5.round()); // 4
  /// print(3.75.round()); // 4
  /// print((-3.5).round()); // -4
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
  /// print(3.0.roundToDouble()); // 3.0
  /// print(3.25.roundToDouble()); // 3.0
  /// print(3.5.roundToDouble()); // 4.0
  /// print(3.75.roundToDouble()); // 4.0
  /// print((-3.5).roundToDouble()); // -4.0
  /// ```
  double? roundToDouble() => _value?.roundToDouble();

  double operator +(other) => isNotNull
      ? set(value! + other)!
      : throw EmpireNullValueException(StackTrace.current, propertyName, runtimeType);

  double operator -(other) => isNotNull
      ? set(value! - other)!
      : throw EmpireNullValueException(StackTrace.current, propertyName, runtimeType);

  double operator /(other) => isNotNull
      ? set(value! / other)!
      : throw EmpireNullValueException(StackTrace.current, propertyName, runtimeType);

  double operator %(other) => isNotNull
      ? set(value! % other)!
      : throw EmpireNullValueException(StackTrace.current, propertyName, runtimeType);

  double operator *(other) => isNotNull
      ? set(value! * other)!
      : throw EmpireNullValueException(StackTrace.current, propertyName, runtimeType);
}
