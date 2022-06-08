// ignore_for_file: depend_on_referenced_packages

import 'package:empire/empire_view_model.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart' show Uuid;

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

  static EmpireApp of(BuildContext context) {
    final EmpireApp? result = context.dependOnInheritedWidgetOfExactType<EmpireApp>();
    assert(result != null, 'No Empire found in context');
    return result!;
  }

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
