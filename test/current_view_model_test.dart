import 'package:current/current.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestViewModel extends CurrentViewModel {
  final name = CurrentStringProperty('Bob');
  final age = CurrentIntProperty(20);

  @override
  Iterable<CurrentProperty> get currentProps => [name, age];
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

  test('setBusyStatus', () {
    const taskKeyOne = 'taskOne';
    const taskKeyTwo = 'taskTwo';
    const taskKeyThree = 'taskThree';

    //Set all tasks to busy
    viewModel.setBusyStatus(isBusy: true, busyTaskKey: taskKeyOne);

    expect(viewModel.busy, isTrue);

    bool isTaskKeyOneBusy = viewModel.isTaskInProgress(taskKeyOne);

    expect(isTaskKeyOneBusy, isTrue);

    viewModel.setBusyStatus(isBusy: true, busyTaskKey: taskKeyTwo);

    expect(viewModel.busy, isTrue);

    bool isTaskKeyTwoBusy = viewModel.isTaskInProgress(taskKeyTwo);

    expect(isTaskKeyTwoBusy, isTrue);

    viewModel.setBusyStatus(isBusy: true, busyTaskKey: taskKeyThree);

    expect(viewModel.busy, isTrue);

    bool isTaskKeyThreeBusy = viewModel.isTaskInProgress(taskKeyThree);

    expect(isTaskKeyThreeBusy, isTrue);

    //Incrementally remove busy status
    viewModel.setBusyStatus(isBusy: false, busyTaskKey: taskKeyOne);

    isTaskKeyOneBusy = viewModel.isTaskInProgress(taskKeyOne);

    expect(isTaskKeyOneBusy, isFalse);
    expect(viewModel.busy, isTrue);

    viewModel.setBusyStatus(isBusy: false, busyTaskKey: taskKeyTwo);

    isTaskKeyTwoBusy = viewModel.isTaskInProgress(taskKeyTwo);

    expect(isTaskKeyTwoBusy, isFalse);
    expect(viewModel.busy, isTrue);

    viewModel.setBusyStatus(isBusy: false, busyTaskKey: taskKeyThree);

    isTaskKeyThreeBusy = viewModel.isTaskInProgress(taskKeyThree);

    expect(isTaskKeyThreeBusy, isFalse);
    expect(viewModel.busy, isFalse);
  });
}
