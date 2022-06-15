import 'dart:async';

import 'package:empire/empire.dart';
import 'package:flutter/material.dart';
import 'application_view_model.dart';
import 'counter_view_model.dart';

class CounterPage extends EmpireWidget<CounterViewModel> {
  const CounterPage({Key? key, required CounterViewModel viewModel}) : super(key: key, viewModel: viewModel);

  @override
  EmpireState<EmpireWidget<EmpireViewModel>, CounterViewModel> createEmpire() => _CounterPageState(viewModel);
}

class _CounterPageState extends EmpireState<CounterPage, CounterViewModel> {
  _CounterPageState(super.viewModel);

  late ApplicationViewModel appViewModel;

  StreamSubscription? countChangedSubscription;

  Future<void> subscribeToCountChanges() async {
    if (countChangedSubscription == null) {
      countChangedSubscription = viewModel.addOnStateChangedListener((events) {
        for (var event in events) {
          if (event.propertyName == "count" && viewModel.changeBackgroundOnCountChange.isTrue) {
            appViewModel.randomizeBackgroundColor();
          }
        }
      });
    } else {
      countChangedSubscription!.resume();
    }

    viewModel.changeBackgroundOnCountChange(true);
  }

  Future<void> unsubscribeToCountChanges() async {
    countChangedSubscription?.pause();
    viewModel.changeBackgroundOnCountChange(false);
  }

  @override
  void didChangeDependencies() {
    appViewModel = Empire.of<ApplicationViewModel>(context).viewModel();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appViewModel.backgroundColor.value,
      appBar: AppBar(
        title: Text(appViewModel.title.value),
      ),
      body: Center(
        child: ifBusy(
          const CircularProgressIndicator(),
          otherwise: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '${viewModel.count}',
                style: Theme.of(context).textTheme.headline4,
              ),
              TextButton(
                onPressed: () =>
                    Empire.viewModelOf<ApplicationViewModel>(context).changeBackgroundColor(Colors.red),
                child: const Text('Red'),
              ),
              TextButton(
                onPressed: () =>
                    Empire.viewModelOf<ApplicationViewModel>(context).changeBackgroundColor(Colors.white),
                child: const Text('White'),
              ),
              TextButton(
                onPressed: () async {
                  if (viewModel.changeBackgroundOnCountChange.isFalse) {
                    await subscribeToCountChanges();
                  } else {
                    await unsubscribeToCountChanges();
                  }
                },
                child: Text(viewModel.changeBackgroundOnCountChange.isFalse
                    ? 'Randomize Background Color on Count Change'
                    : 'Turn Off Random Backgrounds'),
              ),
              TextButton(
                onPressed: () {
                  viewModel.reset();
                  appViewModel.reset();
                },
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
