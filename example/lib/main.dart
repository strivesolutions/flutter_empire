import 'package:empire/empire.dart';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'application_view_model.dart';
import 'counter_page.dart';
import 'counter_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Empire State Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Empire(
        ApplicationViewModel(),
        onAppStateChanged: () => const Uuid().v1(),
        child: CounterPage(
          viewModel: CounterViewModel(),
        ),
      ),
    );
  }
}
