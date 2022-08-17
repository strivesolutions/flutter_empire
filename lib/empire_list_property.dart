part of 'empire_property.dart';

///An [EmpireProperty] with similar characteristics as a dart [List<T>]
///
///Any change to the internal list will send a [EmpireStateChanged] event by default. This includes
///automatically triggering a UI rebuild.
class EmpireListProperty<T> extends EmpireProperty<List<T>> {
  EmpireListProperty(super.value, super.viewModel, {super.propertyName}) {
    _originalValue = List<T>.from(value);
  }

  /// The number of objects in this list.
  ///
  /// The valid indices for a list are `0` through `length - 1`.
  /// ```dart
  /// final numbers = <int>[1, 2, 3];
  /// print(numbers.length); // 3
  /// ```
  int get length => _value.length;

  /// Whether this value has no elements.
  ///
  /// Example:
  /// ```dart
  /// final emptyList = createEmptyListProperty<String>()
  /// print(emptyList.isEmpty); // true;
  /// ```
  bool get isEmpty => _value.isEmpty;

  /// Whether this value has no elements.
  ///
  /// Example:
  /// ```dart
  /// final list = createListProperty<String>(['Bob'])
  /// print(list.isNotEmpty); // true;
  /// ```
  bool get isNotEmpty => _value.isNotEmpty;

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
      _viewModel
          .notifyChanges([EmpireStateChanged.removedFromList(removedValue)]);
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
    final stateChangedEvent =
        EmpireStateChanged.clearedList(_value, propertyName: propertyName);
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
  Iterable<E> map<E>(E Function(T) toElement) {
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
