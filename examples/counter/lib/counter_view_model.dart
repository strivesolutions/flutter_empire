import 'package:empire/empire_property.dart';
import 'package:empire/empire_view_model.dart';

class CounterViewModel extends EmpireViewModel {
  late final EmpireIntProperty count;

  @override
  void initProperties() {
    count = createIntProperty(0);
  }

  Future<void> incrementCounter() async {
    count(count + 1);
  }
}
