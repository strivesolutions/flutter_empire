// ignore_for_file: depend_on_referenced_packages

import 'package:empire/empire_view_model.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart' show Uuid;

///This widget is not intended to be create manually and is used by the [Empire] widget. However,
///that doesn't mean you can't use it manually for your own use case. See [Empire] for more details.
///
///[_uuid] is used to track whether or not this widget should notify its children that they need to
///rebuild.
///
///[viewModel] should contain any properties or functions that any child below this widget need
///access to.
class EmpireApp extends InheritedWidget {
  const EmpireApp(
    this._uuid, {
    Key? key,
    required super.child,
    required this.viewModel,
  }) : super(key: key);

  final String? _uuid;
  final T Function<T extends EmpireViewModel>() viewModel;

  @override
  bool updateShouldNotify(covariant EmpireApp oldWidget) {
    return oldWidget._uuid != _uuid;
  }
}

///Intended to be used near the root of the application to supply app level state and functions. This
///widget must below your [CupertinoApp] or [MaterialApp] widget.
///
///The [viewModel] should contain any state or functionality that is required by one or more child
///widgets. See [viewModelOf] for information on accessing the view model.
class Empire<T extends EmpireViewModel> extends StatefulWidget {
  final T viewModel;
  final Widget child;
  const Empire(
    this.viewModel, {
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<Empire> createState() => _EmpireState<T>();

  ///Gets the instance of the [EmpireApp]. You can access the associated view model via the returned
  ///[EmpireApp]. However you'll most likely want to use the shorthand [viewModelOf] function to do
  ///so.
  static EmpireApp of(BuildContext context) {
    final EmpireApp? result = context.dependOnInheritedWidgetOfExactType<EmpireApp>();
    assert(result != null, 'No Empire found in context');
    return result!;
  }

  ///Gets the [EmpireViewModel] from the [EmpireApp]. This method can be called from any widget
  ///below this one in the widget tree. (Example: from a child widget):
  ///```dart
  ///Empire.viewModelOf<MyApplicationViewModel>().logOut();
  ///```
  static T viewModelOf<T extends EmpireViewModel>(BuildContext context) {
    final EmpireApp result = of(context);
    return result.viewModel<T>();
  }
}

class _EmpireState<T extends EmpireViewModel> extends State<Empire> {
  String? _applicationStateId;

  @override
  void initState() {
    const uuid = Uuid();
    widget.viewModel.addOnStateChangedListener((_) {
      setState(() {
        _applicationStateId = uuid.v1();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EmpireApp(
      _applicationStateId,
      viewModel: <E extends EmpireViewModel>() => widget.viewModel as E,
      child: Builder(builder: (context) {
        return widget.child;
      }),
    );
  }
}
