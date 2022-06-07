import 'package:empire/empire_view_model.dart';
import 'package:flutter/material.dart';

class ApplicationViewModel extends EmpireViewModel {
  late final EmpireProperty<Color> backgroundColor;
  @override
  void initProperties() {
    backgroundColor = createProperty(Colors.white, propertyName: 'backgroundColor');
  }

  void changeBackgroundColor(Color color) => backgroundColor(color);
}
