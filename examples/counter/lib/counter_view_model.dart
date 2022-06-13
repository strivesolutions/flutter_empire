import 'package:empire/empire_property.dart';
import 'package:empire/empire_view_model.dart';

class CounterViewModel extends EmpireViewModel {
  late final EmpireProperty<int> count;

  @override
  void initProperties() {
    count = createProperty(0, propertyName: 'count');
  }

  Future<void> incrementCounter() async {
    count(count.value + 1);
  }
}
