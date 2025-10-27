import 'package:current/current.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class BoolViewModel extends CurrentViewModel {
  final isAwesome = CurrentBoolProperty(true);

  @override
  Iterable<CurrentProperty> get currentProps => [isAwesome];
}

class BoolTestWidget extends CurrentWidget<BoolViewModel> {
  const BoolTestWidget({
    Key? key,
    required BoolViewModel viewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  CurrentState<CurrentWidget<CurrentViewModel>, BoolViewModel> createCurrent() {
    return _BoolTestWidgetState(viewModel);
  }
}

class _BoolTestWidgetState extends CurrentState<BoolTestWidget, BoolViewModel> {
  _BoolTestWidgetState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (innerContext) {
            return Center(
              child: Column(
                children: [
                  Text('${viewModel.isAwesome}'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class NullableBoolViewModel extends CurrentViewModel {
  final isAwesome = CurrentNullableBoolProperty();

  @override
  Iterable<CurrentProperty> get currentProps => [isAwesome];
}

void main() {
  group('CurrentBoolProperty Tests', () {
    late BoolViewModel viewModel;
    late BoolTestWidget testWidget;
    setUp(() {
      viewModel = BoolViewModel();
      testWidget = BoolTestWidget(viewModel: viewModel);
    });

    testWidgets('bool value changes - widget updates', (tester) async {
      await tester.pumpWidget(testWidget);

      expect(find.text("true"), findsOneWidget);

      viewModel.isAwesome(false);

      await tester.pumpAndSettle();

      expect(find.text("false"), findsOneWidget);
    });

    test('isTrue - value is true - returns true', () {
      viewModel.isAwesome(true);
      expect(viewModel.isAwesome.isTrue, isTrue);
    });

    test('isTrue - value is false - returns false', () {
      viewModel.isAwesome(false);
      expect(viewModel.isAwesome.isTrue, isFalse);
    });

    test('isFalse - value is false - returns true', () {
      viewModel.isAwesome(false);
      expect(viewModel.isAwesome.isFalse, isTrue);
    });

    test('isFalse - value is true - returns false', () {
      viewModel.isAwesome(true);
      expect(viewModel.isAwesome.isFalse, isFalse);
    });

    test('setTrue - value is true', () {
      viewModel.isAwesome.set(false);
      viewModel.isAwesome.setTrue();
      expect(viewModel.isAwesome.isTrue, isTrue);
    });

    test('setFalse - value is false', () {
      viewModel.isAwesome.set(true);
      viewModel.isAwesome.setFalse();
      expect(viewModel.isAwesome.isFalse, isTrue);
    });
  });

  group('CurrentNullableBoolProperty Tests', () {
    late NullableBoolViewModel viewModel;

    setUp(() {
      viewModel = NullableBoolViewModel();
    });

    test('isTrue - value is true - returns true', () {
      viewModel.isAwesome(true);
      expect(viewModel.isAwesome.isTrue, isTrue);
    });

    test('isTrue - value is false - returns false', () {
      viewModel.isAwesome(false);
      expect(viewModel.isAwesome.isTrue, isFalse);
    });

    test('isTrue - value is null - returns false', () {
      viewModel.isAwesome(null);
      expect(viewModel.isAwesome.isTrue, isFalse);
    });

    test('isFalse - value is false - returns true', () {
      viewModel.isAwesome(false);
      expect(viewModel.isAwesome.isFalse, isTrue);
    });

    test('isFalse - value is true - returns false', () {
      viewModel.isAwesome(true);
      expect(viewModel.isAwesome.isFalse, isFalse);
    });

    test('isFalse - value is null - returns false', () {
      viewModel.isAwesome(null);
      expect(viewModel.isAwesome.isFalse, isFalse);
    });

    test('setTrue - value is true', () {
      viewModel.isAwesome.set(false);
      viewModel.isAwesome.setTrue();
      expect(viewModel.isAwesome.isTrue, isTrue);
    });

    test('setFalse - value is false', () {
      viewModel.isAwesome.set(true);
      viewModel.isAwesome.setFalse();
      expect(viewModel.isAwesome.isFalse, isTrue);
    });

    test('setNull - value is null', () {
      viewModel.isAwesome.set(false);
      viewModel.isAwesome.setNull();
      expect(viewModel.isAwesome.isNull, isTrue);
    });
  });
}
