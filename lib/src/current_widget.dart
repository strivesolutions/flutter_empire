import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'current_view_model.dart';

///Base class for any widget that needs to be updated when the state of your widget changes.
///
///Requires a class that extends [CurrentViewModel] to be passed to the [viewModel] argument. The
///[CurrentViewModel] is responsible for notifying this widget when the UI needs to be updated.
///
///### Usage
///
///```dart
///class MyWidget extends CurrentWidget<MyViewModel> {
///
///    const MyWidget({super.key, required super.viewModel});
///
///    @override
///    CurrentState<CurrentWidget<CurrentViewModel>, MyViewModel> createCurrent() => _MyWidgetState(viewModel);
///
///}
///```
abstract class CurrentWidget<T extends CurrentViewModel>
    extends StatefulWidget {
  final T viewModel;
  final bool debugPrintStateChanges;
  const CurrentWidget({
    Key? key,
    required this.viewModel,
    this.debugPrintStateChanges = false,
  }) : super(key: key);

  ///Create an instance of [CurrentState] for this widget.
  ///
  ///**IMPORTANT**
  ///This function replaces the default [createState] function. Under the hood, [createCurrent] overrides
  ///the [createState] function. Overriding this function and the [createState] function can have
  ///unintended side affects.
  CurrentState<CurrentWidget, T> createCurrent();

  ///Avoid overriding this function. [createCurrent] handles the creation of the widget state.
  ///Overriding this function can have unintended side affects. You've been warned.
  @mustCallSuper
  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return createCurrent();
  }
}

///Base class for your [CurrentWidget]s accompanying State class.
///
///Will automatically trigger a rebuild when any of this objects accompanying [CurrentViewModel]
///properties change.
///
///### Usage
///
///```dart
///class _CounterPageState extends CurrentState<CounterPage, CounterViewModel> {
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
abstract class CurrentState<T extends CurrentWidget, E extends CurrentViewModel>
    extends State<T> {
  final E viewModel;

  ///Exposes the [viewModel] busy status. Used to determine if the [viewModel] is busy running
  ///a long running task
  bool get isBusy => viewModel.busy;

  CurrentState(this.viewModel) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => viewModel.assignTo(widget.hashCode),
    );

    viewModel.addOnStateChangedListener((events) {
      if (widget.debugPrintStateChanges && kDebugMode) {
        // ignore: avoid_print
        events.forEach(print);
      }
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
