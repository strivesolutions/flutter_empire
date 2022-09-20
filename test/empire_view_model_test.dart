import 'package:empire/empire.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestViewModel extends EmpireViewModel {
  final name = EmpireStringProperty('Bob');
  final age = EmpireIntProperty(20);

  @override
  Iterable<EmpireProperty> get empireProps => [name, age];
}

void main() {
  late _TestViewModel viewModel;

  setUp(() {
    viewModel = _TestViewModel();
  });

  test(
      'resetAll - change property values - All values equal their original value',
      () {
    const changedName = 'Steve';
    const changedAge = 100;
    final originalName = viewModel.name.value;
    final originalAge = viewModel.age.value;

    viewModel.name(changedName);
    viewModel.age(changedAge);

    expect(viewModel.name.value, equals(changedName));
    expect(viewModel.age.value, equals(changedAge));

    viewModel.resetAll();

    expect(viewModel.name.value, equals(originalName));
    expect(viewModel.age.value, equals(originalAge));
  });
}
