import 'package:empire/empire.dart';

class CounterViewModel extends EmpireViewModel {
  final count = EmpireIntProperty.zero(propertyName: 'count');
  final changeBackgroundOnCountChange = EmpireBoolProperty(false);

  @override
  List<EmpireProperty> get empireProps {
    return [count, changeBackgroundOnCountChange];
  }

  Future<void> incrementCounter() async {
    count.increment();
  }

  void reset() {
    count.reset();
    changeBackgroundOnCountChange.reset();
  }
}
