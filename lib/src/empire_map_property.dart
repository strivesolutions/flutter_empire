part of 'empire_property.dart';

///An [EmpireProperty] with similar characteristics as a dart [Map<K, V>]
///
///Any change to the internal map will send a [EmpireStateChanged] event by default. This includes
///automatically triggering a UI rebuild.
class EmpireMapProperty<K, V> extends EmpireProperty<Map<K, V>> {
  EmpireMapProperty(super.value, {super.propertyName}) {
    _originalValue = Map<K, V>.from(value);
  }

  ///Factory constructor for initializing an [EmpireMapProperty] to an empty [Map].
  ///
  ///See [EmpireProperty] for [propertyName] usages.
  ///
  ///## Example
  ///
  ///```dart
  ///final jsonData = EmpireMapProperty<String, dynamic>.empty();
  ///```
  factory EmpireMapProperty.empty({String? propertyName}) {
    return EmpireMapProperty(<K, V>{}, propertyName: propertyName);
  }

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
      viewModel.notifyChanges([
        EmpireStateChanged.addedMapToMap(other, propertyName: propertyName)
      ]);
    }
  }

  /// Adds the key/value pair to this map.
  ///
  /// If the key of [entry] is already in this map,
  /// the corresponding value is overwritten.
  void addEntry(MapEntry<K, V> entry, {bool notifyChanges = true}) {
    _value.addEntries([entry]);

    if (notifyChanges) {
      viewModel.notifyChanges([
        EmpireStateChanged.addedToMap(entry.key, entry.value,
            propertyName: propertyName)
      ]);
    }
  }

  /// Adds all key/value pairs of [entries] to this map.
  ///
  /// If a key of [entries] is already in this map,
  /// the corresponding value is overwritten.
  ///
  /// The operation is equivalent to doing `this[entry.key] = entry.value`
  /// for each [MapEntry] of the iterable.
  /// ```dart
  /// final planets = EmpireMapProperty<int, String>{1: 'Mercury', 2: 'Venus',
  ///   3: 'Earth', 4: 'Mars'};
  /// final gasGiants = <int, String>{5: 'Jupiter', 6: 'Saturn'};
  /// final iceGiants = <int, String>{7: 'Uranus', 8: 'Neptune'};
  /// planets.addEntries(gasGiants.entries);
  /// planets.addEntries(iceGiants.entries);
  /// print(planets);
  /// // {1: Mercury, 2: Venus, 3: Earth, 4: Mars, 5: Jupiter, 6: Saturn,
  /// //  7: Uranus, 8: Neptune}
  /// ```
  void addEntries(Iterable<MapEntry<K, V>> entries,
      {bool notifyChanges = true}) {
    _value.addEntries(entries);

    if (notifyChanges) {
      viewModel.notifyChanges([
        EmpireStateChanged.addedEntriesToMap(entries,
            propertyName: propertyName)
      ]);
    }
  }

  // Adds the [value] with the given [key] to the map.
  ///
  /// If the [key] is already in this map,
  /// the corresponding value is overwritten.
  void add(K key, V value, {bool notifyChanges = true}) {
    _value.addEntries([MapEntry<K, V>(key, value)]);

    if (notifyChanges) {
      viewModel.notifyChanges([
        EmpireStateChanged.addedToMap(key, value, propertyName: propertyName)
      ]);
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
  /// final largestPlanets = EmpireMapProperty<int, String>{1: 'Jupiter', 2: 'Saturn',
  ///   3: 'Neptune'};
  /// // Key value 8 is missing from list, add it using [ifAbsent].
  /// largestPlanets.update(8, (value) => 'New', ifAbsent: () => 'Mercury');
  /// print(largestPlanets); // {1: Jupiter, 2: Saturn, 3: Neptune, 8: Mercury}
  /// ```
  V update(K key, V Function(V value) update,
      {V Function()? ifAbsent, bool notifyChanges = true}) {
    final originalValue = _value[key];
    final updatedValue = _value.update(key, update, ifAbsent: ifAbsent);

    if (notifyChanges) {
      viewModel.notifyChanges([
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
  /// final terrestrial = EmpireMapProperty<int, String>{1: 'Mercury', 2: 'Venus', 3: 'Earth'};
  /// terrestrial.updateAll((key, value) => value.toUpperCase());
  /// print(terrestrial); // {1: MERCURY, 2: VENUS, 3: EARTH}
  /// ```
  void updateAll(V Function(K key, V value) update,
      {bool notifyChanges = true}) {
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
      viewModel.notifyChanges(stateChangedEvents);
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
  /// final terrestrial = EmpireMapProperty<int, String>{1: 'Mercury', 2: 'Venus', 3: 'Earth'};
  /// final removedValue = terrestrial.remove(2); // Venus
  /// print(terrestrial); // {1: Mercury, 3: Earth}
  /// ```
  V? remove(K key, {bool notifyChanges = true}) {
    final removedValue = _value.remove(key);

    if (notifyChanges) {
      viewModel.notifyChanges([
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
  /// final terrestrial = EmpireMapProperty<int, String>{1: 'Mercury', 2: 'Venus', 3: 'Earth'};
  /// terrestrial.removeWhere((key, value) => value.startsWith('E'));
  /// print(terrestrial); // {1: Mercury, 2: Venus}
  /// ```
  void removeWhere(bool Function(K key, V value) test,
      {bool notifyChanges = true}) {
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
      viewModel.notifyChanges(stateChangedEvents);
    }
  }

  /// Removes all entries from the map.
  ///
  /// After this, the map is empty.
  /// ```dart
  /// final planets = EmpireMapProperty<int, String>{1: 'Mercury', 2: 'Venus', 3: 'Earth'};
  /// planets.clear(); // {}
  /// ```
  void clear({bool notifyChanges = true}) {
    final stateChangedEvent =
        EmpireStateChanged(<K, V>{}, _value, propertyName: propertyName);

    _value.clear();

    if (notifyChanges) {
      viewModel.notifyChanges([stateChangedEvent]);
    }
  }

  /// Whether this map contains the given [key].
  ///
  /// Returns true if any of the keys in the map are equal to `key`
  /// according to the equality used by the map.
  /// ```dart
  /// final moonCount = EmpireMapProperty<String, int>{'Mercury': 0, 'Venus': 0, 'Earth': 1,
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
  /// final moonCount = EmpireMapProperty<String, int>{'Mercury': 0, 'Venus': 0, 'Earth': 1,
  ///   'Mars': 2, 'Jupiter': 79, 'Saturn': 82, 'Uranus': 27, 'Neptune': 14 };
  /// final moons3 = moonCount.containsValue(3); // false
  /// final moons82 = moonCount.containsValue(82); // true
  /// ```
  bool containsValue(V value) => _value.containsValue(value);

  /// Returns a new map where all entries of this map are transformed by
  /// the given [convert] function.
  Map<K2, V2> map<K2, V2>(
          MapEntry<K2, V2> Function(dynamic, dynamic) convert) =>
      _value.map(convert);

  /// Applies [action] to each key/value pair of the map.
  ///
  /// Calling `action` must not add or remove keys from the map.
  /// ```dart
  /// final planetsByMass = EmpireMapProperty<num, String>{0.81: 'Venus', 1: 'Earth',
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
  void forEach(void Function(dynamic, dynamic) action) =>
      _value.forEach(action);

  V? operator [](K key) {
    return _value[key];
  }

  @override
  void reset({bool notifyChange = true}) {
    final currentValue = _value;
    _value = Map<K, V>.from(_originalValue);

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
}
