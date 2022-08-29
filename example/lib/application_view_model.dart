import 'package:empire/empire.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ApplicationViewModel extends EmpireViewModel {
  final backgroundColor = EmpireProperty(Colors.white);

  final EmpireStringProperty title;

  ApplicationViewModel(this.title);

  @override
  Iterable<EmpireProperty> get empireProps => [backgroundColor, title];

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
