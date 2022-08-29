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
  });
}
