import 'package:empire/empire_properties.dart';
import 'package:empire/empire_view_model.dart';

class CounterViewModel extends EmpireViewModel {
  final count = EmpireIntProperty(0, propertyName: 'count');
  final changeBackgroundOnCountChange = EmpireBoolProperty(false);

  @override
  List<EmpireProperty> get props {
    return [count, changeBackgroundOnCountChange];
  }

  Future<void> incrementCounter() async {
    count(count + 1);
  }

  void reset() {
    count.reset();
    changeBackgroundOnCountChange.reset();
  }
}
