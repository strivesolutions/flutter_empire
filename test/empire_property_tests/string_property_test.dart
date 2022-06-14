import 'package:empire/empire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class StringViewModel extends EmpireViewModel {
  late EmpireStringProperty name;

  @override
  void initProperties() {
    name = createStringProperty('Bob');
  }
}

class StringTestWidget extends EmpireWidget<StringViewModel> {
  const StringTestWidget({
    Key? key,
    required StringViewModel viewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  EmpireState<EmpireWidget<EmpireViewModel>, StringViewModel> createEmpire() {
    return _StringTestWidgetState(viewModel);
  }
}

class _StringTestWidgetState extends EmpireState<StringTestWidget, StringViewModel> {
  _StringTestWidgetState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (innerContext) {
            return Center(
              child: Column(
                children: [
                  Text('${viewModel.name}'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class NullableStringViewModel extends EmpireViewModel {
  late EmpireNullableStringProperty name;

  @override
  void initProperties() {
    name = createNullableStringProperty();
  }
}

void main() {
  group('StringProperty Tests', () {
    late StringViewModel viewModel;
    late StringTestWidget testWidget;

    setUp(() {
      viewModel = StringViewModel();
      testWidget = StringTestWidget(viewModel: viewModel);
    });

    testWidgets('string value changes - widget updates', (tester) async {
      const String expectedValue = 'John';

      await tester.pumpWidget(testWidget);

      expect(find.text(viewModel.name.value), findsOneWidget);

      viewModel.name(expectedValue);

      await tester.pumpAndSettle();

      expect(find.text(expectedValue), findsOneWidget);
    });

    test('isEmpty - value is an empty string - returns true', () {
      viewModel.name('');
      final result = viewModel.name.isEmpty;

      expect(result, isTrue);
    });

    test('isEmpty - value is not an empty string - returns false', () {
      viewModel.name('John');
      final result = viewModel.name.isEmpty;

      expect(result, isFalse);
    });

    test('isNotEmpty - value is an empty string - returns false', () {
      viewModel.name('');
      final result = viewModel.name.isNotEmpty;

      expect(result, isFalse);
    });

    test('isNotEmpty - value is not an empty string - returns true', () {
      viewModel.name('John');
      final result = viewModel.name.isNotEmpty;

      expect(result, isTrue);
    });

    test('length - returns correct int value', () {
      const int expectedValue = 4;
      const String nameValue = 'John';

      viewModel.name(nameValue);
      final result = viewModel.name.length;

      expect(result, equals(expectedValue));
    });

    test('contains - finds matching string - returns true', () {
      const String nameValue = 'John';
      viewModel.name(nameValue);

      final result = viewModel.name.contains('J');

      expect(result, isTrue);
    });

    test('contains - no matching string - returns false', () {
      const String nameValue = 'John';
      viewModel.name(nameValue);

      final result = viewModel.name.contains('X');

      expect(result, isFalse);
    });
  });
}
