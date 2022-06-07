import 'package:empire/empire.dart';
import 'package:empire_example/application_view_model.dart';
import 'package:empire_example/counter_view_model.dart';
import 'package:flutter/material.dart';

import 'counter_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Empire State Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Empire(
        ApplicationViewModel(),
        child: CounterPage(
          title: 'Empire State',
          viewModel: CounterViewModel(),
        ),
      ),
    );
  }
}
