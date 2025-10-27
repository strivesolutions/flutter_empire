import 'package:current/current.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ApplicationViewModel extends CurrentViewModel {
  final backgroundColor = CurrentProperty(Colors.white);

  final CurrentStringProperty title;

  ApplicationViewModel(this.title);

  @override
  Iterable<CurrentProperty> get currentProps => [backgroundColor, title];

  void changeBackgroundColor(Color color) => backgroundColor(color);

  void randomizeBackgroundColor() {
    final color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withValues(alpha: 1);
    backgroundColor(color);
  }

  void reset() {
    backgroundColor.reset();
  }
}
