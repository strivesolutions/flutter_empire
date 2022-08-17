import 'package:empire/empire_property.dart';
import 'package:empire/empire_view_model.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ApplicationViewModel extends EmpireViewModel {
  late final EmpireProperty<Color> backgroundColor;
  late final EmpireStringProperty title;

  @override
  void initProperties() {
    backgroundColor =
        createProperty(Colors.white, propertyName: 'backgroundColor');
    title = createStringProperty('Empire - Counter App Example');
  }

  void changeBackgroundColor(Color color) => backgroundColor(color);

  void randomizeBackgroundColor() {
    final color =
        Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    backgroundColor(color);
  }

  void reset() {
    backgroundColor.reset();
  }
}
