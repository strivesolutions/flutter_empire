import 'package:flutter/material.dart';

import 'empire_view_model.dart';

///Base class for any widget that needs to be updated when the state of your widget changes.
///
///Requires a class that extends [EmpireViewModel] to be passed to the [viewModel] argument. The
///[EmpireViewModel] is responsible for notifying this widget when the UI needs to be updated.
///
///### Usage
///
///```dart
///class MyWidget extends EmpireWidget<MyViewModel> {
///
///    const MyWidget({super.key, required super.viewModel});
///
///    @override
///    EmpireState<EmpireWidget<EmpireViewModel>, MyViewModel> createEmpire() => _MyWidgetState(viewModel);
///
///}
///```
abstract class EmpireWidget<T extends EmpireViewModel> extends StatefulWidget {
  final T viewModel;

  const EmpireWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  ///Create an instance of [EmpireState] for this widget.
  ///
  ///**IMPORTANT**
  ///This function replaces the default [createState] function. Under the hood, [createEmpire] overrides
  ///the [createState] function. Overriding this function and the [createState] function can have
  ///unintended side affects.
  EmpireState<EmpireWidget, T> createEmpire();

  ///Avoid overriding this function. [createEmpire] handles the creation of the widget state.
  ///Overriding this function can have unintended side affects. You've been warned.
  @mustCallSuper
  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return createEmpire();
  }
}

///Base class for your [EmpireWidget]s accompanying State class.
///
///Will automatically trigger a rebuild when any of this objects accompanying [EmpireViewModel]
///properties change.
///
///### Usage
///
///```dart
///class _CounterPageState extends EmpireState<CounterPage, CounterViewModel> {
///  _CounterPageState(super.viewModel);
///
///  @override
///  Widget build(BuildContext context) {
///    return Scaffold(
///      appBar: AppBar(
///        title: Text(widget.title),
///      ),
///      body: Center(
///        child: Column(
///          mainAxisAlignment: MainAxisAlignment.center,
///          children: <Widget>[
///            const Text(
///              'You have pushed the button this many times:',
///            ),
///            Text(
///              '${viewModel.count}',
///            ),
///          ],
///        ),
///      ),
///      floatingActionButton: FloatingActionButton(
///        onPressed: viewModel.incrementCounter,
///        tooltip: 'Increment',
///        child: const Icon(Icons.add),
///      ),
///    );
///  }
///}
///```
abstract class EmpireState<T extends EmpireWidget, E extends EmpireViewModel>
    extends State<T> {
  final E viewModel;

  ///Exposes the [viewModel] busy status. Used to determine if the [viewModel] is busy running
  ///a long running task
  bool get isBusy => viewModel.busy;

  EmpireState(this.viewModel) {
    viewModel.addOnStateChangedListener((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  ///Can be used to conditionally show another widget if the [viewModel] is busy running a long
  ///running task.
  ///
  ///If the view model is busy, it will show the [busyIndicator] widget. If it is not
  ///busy, it will show the [otherwise] widget.
  Widget ifBusy(Widget busyIndicator, {required Widget otherwise}) {
    return isBusy ? busyIndicator : otherwise;
  }

  @override
  @mustCallSuper
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
