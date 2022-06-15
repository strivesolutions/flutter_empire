import 'package:empire/empire_property.dart';
import 'package:empire/empire_view_model.dart';

class CounterViewModel extends EmpireViewModel {
  late final EmpireIntProperty count;
  late final EmpireBoolProperty changeBackgroundOnCountChange;

  @override
  void initProperties() {
    count = createIntProperty(0, propertyName: 'count');
    changeBackgroundOnCountChange = createBoolProperty(false);
  }

  Future<void> incrementCounter() async {
    count(count + 1);
  }
}
