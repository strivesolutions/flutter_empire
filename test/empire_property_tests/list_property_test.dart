import 'package:empire/empire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class ListViewModel extends EmpireViewModel {
  final planets = EmpireListProperty<String>.empty();

  @override
  Iterable<EmpireProperty> get empireProps => [planets];
}

class ListTestWidget extends EmpireWidget<ListViewModel> {
  const ListTestWidget({
    Key? key,
    required ListViewModel viewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  EmpireState<EmpireWidget<EmpireViewModel>, ListViewModel> createEmpire() {
    return _ListTestWidgetState(viewModel);
  }
}

class _ListTestWidgetState extends EmpireState<ListTestWidget, ListViewModel> {
  _ListTestWidgetState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (innerContext) {
            return Center(
              child: Column(
                children: viewModel.planets.value.map((e) => Text(e)).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  group('EmpireListProperty Tests', () {
    late ListViewModel viewModel;
    late ListTestWidget testWidget;
    setUp(() {
      viewModel = ListViewModel();
      testWidget = ListTestWidget(viewModel: viewModel);
    });

    testWidgets('item added - widget updates', (tester) async {
      String earth = 'Earth';

      await tester.pumpWidget(testWidget);

      expect(find.text(earth), findsNothing);

      viewModel.planets.add(earth);

      await tester.pumpAndSettle();

      expect(find.text(earth), findsOneWidget);
    });

    testWidgets('multiple items added - widget updates', (tester) async {
      String earth = 'Earth';
      String venus = 'Venus';

      await tester.pumpWidget(testWidget);

      expect(find.text(earth), findsNothing);
      expect(find.text(venus), findsNothing);

      viewModel.planets.addAll([earth, venus]);

      await tester.pumpAndSettle();

      expect(find.text(earth), findsOneWidget);
      expect(find.text(venus), findsOneWidget);
    });

    testWidgets('remove item - widget updates', (tester) async {
      String earth = 'Earth';
      viewModel.planets.add(earth);

      await tester.pumpWidget(testWidget);

      expect(find.text(earth), findsOneWidget);

      viewModel.planets.remove(earth);

      await tester.pumpAndSettle();

      expect(find.text(earth), findsNothing);
    });

    testWidgets('removeAt - widget updates', (tester) async {
      String earth = 'Earth';
      String venus = 'Venus';

      viewModel.planets.addAll([earth, venus]);

      await tester.pumpWidget(testWidget);

      expect(find.text(earth), findsOneWidget);
      expect(find.text(venus), findsOneWidget);

      viewModel.planets.removeAt(1);

      await tester.pumpAndSettle();

      expect(find.text(earth), findsOneWidget);
      expect(find.text(venus), findsNothing);
    });

    testWidgets('clear - widget updates', (tester) async {
      String earth = 'Earth';
      String venus = 'Venus';

      viewModel.planets.addAll([earth, venus]);

      await tester.pumpWidget(testWidget);

      expect(find.text(earth), findsOneWidget);
      expect(find.text(venus), findsOneWidget);

      viewModel.planets.clear();

      await tester.pumpAndSettle();

      expect(find.text(earth), findsNothing);
      expect(find.text(venus), findsNothing);
    });

    test('contains - contains item - returns true', () {
      String earth = 'Earth';
      viewModel.planets.add(earth);
      final result = viewModel.planets.contains(earth);
      expect(result, isTrue);
    });

    test('contains - does not contain item - returns true', () {
      String earth = 'Earth';
      String venus = 'Venus';

      viewModel.planets.add(earth);

      final result = viewModel.planets.contains(venus);

      expect(result, isFalse);
    });

    test('indexOf - list contains item - returns correct index', () {
      String earth = 'Earth';
      const int expectedIndex = 0;

      viewModel.planets.add(earth);

      final result = viewModel.planets.indexOf(earth);

      expect(result, equals(expectedIndex));
    });

    test('[] operator - pass valid index value - returns correct value', () {
      String earth = 'Earth';

      viewModel.planets.add(earth);

      final result = viewModel.planets[0];

      expect(result, equals(earth));
    });

    test(
        'map - generate different type in map function - returns correct values',
        () {
      String earth = 'Earth';
      String venus = 'Venus';

      viewModel.planets.addAll([earth, venus]);

      final results = viewModel.planets.map((planet) => planet.length).toList();

      expect(results, const TypeMatcher<List<int>>());
    });

    test('isEmpty - list is empty - returns true', () {
      final emptyList = EmpireListProperty<String>.empty();

      expect(emptyList.isEmpty, isTrue);
    });

    test('isEmpty - list is not empty - returns false', () {
      final names = EmpireListProperty<String>(['Bob']);

      expect(names.isEmpty, isFalse);
    });

    test('isNotEmpty - list is empty - returns false', () {
      final list = EmpireListProperty<String>.empty();

      expect(list.isNotEmpty, isFalse);
    });

    test('isNotEmpty - list is not empty - returns true', () {
      final list = EmpireListProperty<String>(['Bob']);

      expect(list.isNotEmpty, isTrue);
    });

    test(
        'reset - starting list is empty - add item - should be empty after reset',
        () {
      final list = EmpireListProperty<String>.empty();
      list.setViewModel(viewModel);
      list.add('Bob');
      list.reset();
      expect(list.isEmpty, isTrue);
    });

    test(
        'reset - starting list has data - remove item - only original data after reset',
        () {
      const String listItem = 'Earth';
      final data = EmpireListProperty<String>([listItem]);
      data.setViewModel(viewModel);

      expect(data.contains(listItem), isTrue);

      data.clear();

      expect(data.contains(listItem), isFalse);

      data.reset();

      expect(data.contains(listItem), isTrue);
    });

    test('ellementAt - list is not empty - returns correct object', () {
      const String expected = 'Frank';
      const int index = 1;
      final list = EmpireListProperty<String>(['Bob', expected]);

      final result = list.elementAt(index);

      expect(result, equals(expected));
    });

    test(
      'where - list is not empty - returns items in list matching prediate',
      () {
        const expectedLength = 3;
        final expectedItems = [3, 4, 5];
        final numbers = EmpireListProperty([1, 2, ...expectedItems]);
        final result = numbers.where((x) => x > 2);

        expect(result.length, equals(expectedLength));
        expect(result, equals(expectedItems));
      },
    );

    test(
      'firstWhere - returns first matching item',
      () {
        const expected = 3;
        final numbers = EmpireListProperty([1, 2, 3]);
        final result = numbers.firstWhere((element) => element == expected);

        expect(result, equals(expected));
      },
    );

    test(
      'firstWhere - no match found - returns result from orElse',
      () {
        const expected = -1;
        final numbers = EmpireListProperty([1, 2, 3]);
        final result = numbers.firstWhere(
          (element) => element == expected,
          orElse: () => expected,
        );

        expect(result, equals(expected));
      },
    );

    test(
      'firstWhereOrNull - match found - returns first matching item',
      () {
        const expected = 3;
        final numbers = EmpireListProperty([1, 2, 3]);
        final result =
            numbers.firstWhereOrNull((element) => element == expected);

        expect(result, equals(expected));
      },
    );

    test(
      'firstWhereOrNull - no match found - returns null',
      () {
        const expected = -1;
        final numbers = EmpireListProperty([1, 2, 3]);
        final result =
            numbers.firstWhereOrNull((element) => element == expected);

        expect(result, isNull);
      },
    );

    test(
      'indexWhere - match found - returns correct index',
      () {
        const expected = 2;
        final numbers = EmpireListProperty([1, 2, 3]);
        final result = numbers.indexWhere((element) => element == 3);

        expect(result, equals(expected));
      },
    );

    test(
      'indexWhere - no match found - returns -1',
      () {
        const expected = -1;
        final numbers = EmpireListProperty([1, 2, 3]);
        final result = numbers.indexWhere((element) => element == expected);

        expect(result, equals(expected));
      },
    );

    test('reversed - returns reversed list', () {
      final expected = [3, 2, 1];
      final numbers = EmpireListProperty([1, 2, 3]);
      final reversed = numbers.reversed;
      expect(reversed, equals(expected));
    });

    test('first - list is not empty - returns first item', () {
      const expected = 1;
      final numbers = EmpireListProperty([1, 2, 3]);
      final first = numbers.first;
      expect(first, equals(expected));
    });

    test('last - list is not empty - returns last item', () {
      const expected = 3;
      final numbers = EmpireListProperty([1, 2, 3]);
      final last = numbers.last;
      expect(last, equals(expected));
    });

    test('single - list contains one item - returns item', () {
      const expected = 1;
      final numbers = EmpireListProperty([expected]);
      final single = numbers.single;
      expect(single, equals(expected));
    });

    test('insert - returns correct item at new index', () {
      const expectedNumber = 10;
      const expectedIndex = 1;
      final numbers = EmpireListProperty([1, 2, 3]);

      numbers.insert(expectedIndex, expectedNumber, notifyChanges: false);

      expect(numbers[expectedIndex], expectedNumber);
    });

    test('insertAll - returns correct items at new index', () {
      const expectedNumbers = [10, 11, 12];
      const expectedIndex = 1;
      final numbers = EmpireListProperty([1, 2, 3]);

      numbers.insertAll(expectedIndex, expectedNumbers, notifyChanges: false);

      expect(
        numbers.sublist(
          expectedIndex,
          expectedNumbers.length + expectedIndex,
        ),
        expectedNumbers,
      );
    });

    test('insertAllAtEnd - returns correct items at end of list', () {
      final expectedNumbers = [10, 11, 12];
      final numbers = EmpireListProperty([1, 2, 3]);
      final initialListLength = numbers.length;

      numbers.insertAllAtEnd(expectedNumbers, notifyChanges: false);

      expect(numbers.sublist(initialListLength), expectedNumbers);
    });

    test('toString - returns correct string', () {
      final numbers = EmpireListProperty([1, 2, 3]);
      const expected = 'EmpireListProperty([1, 2, 3])';
      expect(numbers.toString(), expected);
    });

    test('resetting retains original value', () {
      final numbers = EmpireListProperty<int>.empty();
      final items = [1, 2, 3];

      numbers.addAll(items, notifyChanges: false);

      expect(numbers.originalValue.isEmpty, isTrue);

      numbers.reset(notifyChange: false);

      expect(numbers.originalValue.isEmpty, isTrue);

      numbers.addAll(items, notifyChanges: false);
      expect(numbers.originalValue.isEmpty, isTrue);
    });
  });
}
