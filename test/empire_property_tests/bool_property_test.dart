import 'package:empire/empire.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

class BoolViewModel extends EmpireViewModel {
  late EmpireBoolProperty isAwesome;

  @override
  void initProperties() {
    isAwesome = createBoolProperty(true);
  }
}

class BoolTestWidget extends EmpireWidget<BoolViewModel> {
  const BoolTestWidget({
    Key? key,
    required BoolViewModel viewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  EmpireState<EmpireWidget<EmpireViewModel>, BoolViewModel> createEmpire() {
    return _BoolTestWidgetState(viewModel);
  }
}

class _BoolTestWidgetState extends EmpireState<BoolTestWidget, BoolViewModel> {
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

class NullableBoolViewModel extends EmpireViewModel {
  late final EmpireNullableBoolProperty isAwesome;

  @override
  void initProperties() {
    isAwesome = createNullableBoolProperty();
  }
}

void main() {
  group('EmpireBoolProperty Tests', () {
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
  });

  group('EmpireNullableBoolProperty Tests', () {
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
  });
}
