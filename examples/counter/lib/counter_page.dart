import 'package:empire/empire.dart';
import 'package:empire/empire_state.dart';
import 'package:empire/empire_view_model.dart';
import 'package:empire_example/application_view_model.dart';
import 'package:empire_example/counter_view_model.dart';
import 'package:flutter/material.dart';

class CounterPage extends EmpireWidget<CounterViewModel> {
  const CounterPage({Key? key, required this.title, required CounterViewModel viewModel})
      : super(key: key, viewModel: viewModel);
  final String title;

  @override
  EmpireState<EmpireWidget<EmpireViewModel>, CounterViewModel> createEmpire() => _CounterPageState(viewModel);
}

class _CounterPageState extends EmpireState<CounterPage, CounterViewModel> {
  _CounterPageState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Empire.of(context).viewModel<ApplicationViewModel>().backgroundColor.value,
      appBar: AppBar(
        title: Text(widget.title),
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
                onPressed: () => viewModel.count(0),
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.count(viewModel.count.value + 1),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
