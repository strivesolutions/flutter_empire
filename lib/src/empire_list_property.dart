part of 'empire_property.dart';

///An [EmpireProperty] with similar characteristics as a dart [List<T>]
///
///Any change to the internal list will send a [EmpireStateChanged] event by default. This includes
///automatically triggering a UI rebuild.
class EmpireListProperty<T> extends EmpireProperty<List<T>> {
  EmpireListProperty(super.value, {super.propertyName}) {
    _originalValue = List<T>.from(value);
  }

  ///Factory constructor for initializing an [EmpireListProperty] to an empty [List].
  ///
  ///See [EmpireProperty] for [propertyName] usages.
  ///
  ///## Example
  ///
  ///```dart
  ///final marsOneVolunteers = EmpireListProperty<People>.empty();
  ///```
  factory EmpireListProperty.empty({String? propertyName}) {
    return EmpireListProperty(<T>[], propertyName: propertyName);
  }

  /// Returns the first element.
  ///
  /// Throws a [StateError] if `this` is empty.
  /// Otherwise returns the first element in the iteration order,
  /// equivalent to `this.elementAt(0)`.
  T get first => _value.first;

  /// Returns the last element.
  ///
  /// Throws a [StateError] if `this` is empty.
  /// Otherwise may iterate through the elements and returns the last one
  /// seen.
  T get last => _value.last;

  /// Checks that this has only one element, and returns that element.
  ///
  /// Throws a [StateError] if `this` is empty or has more than one element.
  T get single => _value.single;

  /// A [List] of the objects in this list in reverse order.
  /// ```dart
  /// final numbers = EmpireListProperty['two', 'three', 'four'];
  /// final reverseOrder = numbers.reversed;
  /// print(reverseOrder.toList()); // [four, three, two]
  /// ```
  List<T> get reversed => _value.reversed.toList();

  /// The number of objects in this list.
  ///
  /// The valid indices for a list are `0` through `length - 1`.
  /// ```dart
  /// final numbers = EmpireListProperty<int>[1, 2, 3];
  /// print(numbers.length); // 3
  /// ```
  int get length => _value.length;

  /// Whether this value has no elements.
  ///
  /// Example:
  /// ```dart
  /// final emptyList = EmpireListProperty<String>([])
  /// print(emptyList.isEmpty); // true;
  /// ```
  bool get isEmpty => _value.isEmpty;

  /// Whether this value has no elements.
  ///
  /// Example:
  /// ```dart
  /// final list = EmpireListProperty<String>(['Bob'])
  /// print(list.isNotEmpty); // true;
  /// ```
  bool get isNotEmpty => _value.isNotEmpty;

  /// Returns a new [List] with all elements that satisfy the
  /// predicate [test].
  ///
  /// Example:
  /// ```dart
  /// final numbers = EmpireListProperty[1, 2, 3, 5, 6, 7];
  /// var result = numbers.where((x) => x < 5); // (1, 2, 3)
  /// result = numbers.where((x) => x > 5); // (6, 7)
  /// result = numbers.where((x) => x.isEven); // (2, 6)
  /// ```
  List<T> where(bool Function(T element) test) {
    return _value.where(test).toList();
  }

  /// Returns the first element that satisfies the given predicate [test].
  ///
  /// Iterates through elements and returns the first to satisfy [test].
  ///
  /// Example:
  /// ```dart
  /// final numbers = EmpireListProperty[1, 2, 3, 5, 6, 7];
  /// var result = numbers.firstWhere((element) => element < 5); // 1
  /// result = numbers.firstWhere((element) => element > 5); // 6
  /// result =
  ///     numbers.firstWhere((element) => element > 10, orElse: () => -1); // -1
  /// ```
  ///
  /// If no element satisfies [test], the result of invoking the [orElse]
  /// function is returned.
  /// If [orElse] is omitted, it defaults to throwing a [StateError].
  T firstWhere(bool Function(T element) test, {T Function()? orElse}) {
    return value.firstWhere(test, orElse: orElse);
  }

  /// Returns the first element that satisfies the given predicate [test].
  ///
  /// Iterates through elements and returns the first to satisfy [test].
  ///
  /// Example:
  /// ```dart
  /// final numbers = EmpireListProperty[1, 2, 3, 5, 6, 7];
  /// var result = numbers.firstWhere((element) => element < 5); // 1
  /// result = numbers.firstWhere((element) => element > 5); // 6
  /// result =
  ///     numbers.firstWhere((element) => element > 10, orElse: () => -1); // -1
  /// ```
  ///
  /// If no element satisfies [test], null is returned
  T? firstWhereOrNull(bool Function(T element) test) {
    final results = value.where(test);

    if (results.isEmpty) {
      return null;
    } else {
      return results.first;
    }
  }

  /// Adds [value] to the end of this list,
  /// extending the length by one.
  ///
  /// The list must be growable.
  ///
  /// ```dart
  /// final numbers = EmpireListProperty<int>[1, 2, 3];
  /// numbers.add(4);
  /// print(numbers); // [1, 2, 3, 4]
  /// ```
  void add(T value, {bool notifyChanges = true}) {
    _value.add(value);

    if (notifyChanges) {
      viewModel.notifyChanges([EmpireStateChanged.addedToList(value)]);
    }
  }

  /// Appends all objects of [values] to the end of the list.
  ///
  /// Extends the length of the list by the number of objects in [values].
  /// The list must be growable.
  ///
  /// ```dart
  /// final numbers = EmpireListProperty<int>[1, 2, 3];
  /// numbers.addAll([4, 5, 6]);
  /// print(numbers); // [1, 2, 3, 4, 5, 6]
  /// ```
  void addAll(Iterable<T> values, {bool notifyChanges = true}) {
    _value.addAll(values);

    if (notifyChanges) {
      viewModel.notifyChanges([EmpireStateChanged.addedAllToList(values)]);
    }
  }

  /// Removes the first occurrence of [value] from this list.
  ///
  /// Returns true if [value] was in the list, false otherwise.
  /// The list must be growable.
  ///
  /// ```dart
  /// final parts = EmpireListProperty<String>['head', 'shoulders', 'knees', 'toes'];
  /// final retVal = parts.remove('head'); // true
  /// print(parts); // [shoulders, knees, toes]
  /// ```
  /// The method has no effect if [value] was not in the list.
  /// ```dart
  /// final parts = EmpireListProperty<String>['shoulders', 'knees', 'toes'];
  /// // Note: 'head' has already been removed.
  /// final retVal = parts.remove('head'); // false
  /// print(parts); // [shoulders, knees, toes]
  /// ```
  bool remove(T value, {bool notifyChanges = true}) {
    final wasRemoved = _value.remove(value);

    if (notifyChanges && wasRemoved) {
      viewModel.notifyChanges([EmpireStateChanged.removedFromList(value)]);
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
  /// final parts = EmpireListProperty<String>['head', 'shoulder', 'knees', 'toes'];
  /// final retVal = parts.removeAt(2); // knees
  /// print(parts); // [head, shoulder, toes]
  /// ```
  T removeAt(int index, {bool notifyChanges = true}) {
    final removedValue = _value.removeAt(index);

    if (notifyChanges) {
      viewModel
          .notifyChanges([EmpireStateChanged.removedFromList(removedValue)]);
    }

    return removedValue;
  }

  /// Removes all objects from this list; the length of the list becomes zero.
  ///
  /// The list must be growable.
  ///
  /// ```dart
  /// final numbers = EmpireListProperty<int>[1, 2, 3];
  /// numbers.clear();
  /// print(numbers.length); // 0
  /// print(numbers); // []
  /// ```
  void clear({bool notifyChanges = true}) {
    final stateChangedEvent =
        EmpireStateChanged.clearedList(_value, propertyName: propertyName);
    _value.clear();

    if (notifyChanges) {
      viewModel.notifyChanges([stateChangedEvent]);
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
  ///
  /// Example:
  /// ```dart
  /// final gasPlanets = EmpireListProperty<String>(['Jupiter', 'Saturn']);
  /// final containsEarth = gasPlanets.contains('Earth'); // false
  /// final containsJupiter = gasPlanets.contains('Jupiter'); // true
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
  /// Example:
  /// ```dart
  /// var products = EmpireListProperty(
  /// [
  ///   {"name": "Screwdriver", "price": 42.00},
  ///   {"name": "Wingnut", "price": 0.50}
  /// ]);
  /// var values = products.map((product) => product['price'] as double);
  /// var totalPrice = values.fold(0.0, (a, b) => a + b); // 42.5.
  /// ```
  Iterable<E> map<E>(E Function(T) toElement) {
    return _value.map(toElement);
  }

  /// Returns the [index]th element.
  ///
  /// The [index] must be non-negative and less than [length].
  /// Index zero represents the first element (so `iterable.elementAt(0)` is
  /// equivalent to `iterable.first`).
  ///
  /// May iterate through the elements in iteration order, ignoring the
  /// first [index] elements and then returning the next.
  /// Some iterables may have a more efficient way to find the element.
  ///
  /// Example:
  /// ```dart
  /// final numbers = EmpireListProperty<int>[1, 2, 3, 5, 6, 7];
  /// final elementAt = numbers.elementAt(4); // 6
  /// ```
  T elementAt(int index) {
    return _value.elementAt(index);
  }

  /// Invokes [action] on each element of this iterable in iteration order.
  ///
  /// Example:
  /// ```dart
  /// final numbers = EmpireListProperty<int>[1, 2, 6, 7];
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
  /// final notes = EmpireListProperty<String>['do', 're', 'mi', 're'];
  /// print(notes.indexOf('re')); // 1
  ///
  /// final indexWithStart = notes.indexOf('re', 2); // 3
  /// ```
  /// Returns -1 if [value] is not found.
  /// ```dart
  /// final notes = EmpireListProperty<String>['do', 're', 'mi', 're'];
  /// final index = notes.indexOf('fa'); // -1
  /// ```
  int indexOf(T value, [int start = 0]) => _value.indexOf(value, start);

  /// The first index in the list that satisfies the provided [test].
  ///
  /// Searches the list from index [start] to the end of the list.
  /// The first time an object `o` is encountered so that `test(o)` is true,
  /// the index of `o` is returned.
  ///
  /// ```dart
  /// final notes = EmpireListProperty<String>(['do', 're', 'mi', 're']);
  /// final first = notes.indexWhere((note) => note.startsWith('r')); // 1
  /// final second = notes.indexWhere((note) => note.startsWith('r'), 2); // 3
  /// ```
  ///
  /// Returns -1 if [element] is not found.
  /// ```dart
  /// final notes = EmpireListProperty<String>['do', 're', 'mi', 're'];
  /// final index = notes.indexWhere((note) => note.startsWith('k')); // -1
  /// ```
  int indexWhere(bool Function(T element) test, [int start = 0]) {
    return value.indexWhere(test, start);
  }

  /// The object at the given [index] in the list.
  ///
  /// The [index] must be a valid index of this list,
  /// which means that `index` must be non-negative and
  /// less than [length].
  T operator [](int index) {
    return _value[index];
  }
}
