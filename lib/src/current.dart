import 'package:current/current.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

///This widget is not intended to be created manually and is used by the [Current] widget.
///
///[_uuid] is used to track whether or not this widget should notify its children that they need to
///rebuild.
///
///[viewModel] should contain any properties or functions that any child below this widget need
///access to.
class CurrentApp<T extends CurrentViewModel> extends InheritedWidget {
  const CurrentApp(
    this._uuid, {
    Key? key,
    required super.child,
    required this.viewModel,
  }) : super(key: key);

  final String? _uuid;
  final T Function() viewModel;

  @override
  bool updateShouldNotify(covariant CurrentApp oldWidget) {
    return oldWidget._uuid != _uuid;
  }
}

///Used to provide shared state and functions across specific scopes of your application, or the
///entire application itself.
///
///The [viewModel] should contain any state or functionality that is required by one or more child
///widgets. See [viewModelOf] for information on accessing the view model.
///
///[onAppStateChanged] is required and should return a unique [String] value each time it is called.
///This is used to determine whether the [CurrentApp] inherited widget needs to be updated, therefore
///updating all it's child widgets. Consider using the [Uuid](https://pub.dev/packages/uuid) package.
///
///*If you are implementing your own unique string mechanism, know that if it generates the same value
///twice in a row, your second change will not be reflected in the application until a new, unique
///value is generated.*
///
///### Example Using Uuid
///
///```dart
///import 'package:uuid/uuid.dart';
///
///Current(
///  myViewModel,
///  child: HomePage(),
///  onAppStateChanged: () => Uuid().v1(),
///)
///```
///
///### Nested / Scoped Currents
///
///```dart
///Current(
///  MyApplicationViewModel(),
///  onAppStateChanged: () => Uuid().v1(),
///  child: MaterialApp(
///   title: 'My App',
///   home: Scaffold(
///     backgroundColor: Current.viewModelOf<MyApplicationViewModel>().backgroundColor.value,
///     child: Current(
///       MyHomePageViewModel(),
///       onAppStateChanged: () => Uuid().v1(),
///       child: Builder(builder: (innerContext){
///         return Center(
///           child: Text(${Current.viewModelOf<MyHomePageViewModel>().title.value})
///         );
///       }),
///     )
///   )
///  )
///)
///
///```
class Current<T extends CurrentViewModel> extends StatefulWidget {
  final T viewModel;
  final Widget child;
  final String Function() onAppStateChanged;
  final bool debugPrintStateChanges;

  const Current(
    this.viewModel, {
    Key? key,
    required this.child,
    required this.onAppStateChanged,
    this.debugPrintStateChanges = false,
  }) : super(key: key);

  @override
  State<Current> createState() => _CurrentState<T>();

  ///Gets the instance of the [CurrentApp] that matches the generic type argument [T].
  ///
  ///You can access the associated view model via the returned
  ///[CurrentApp]. However you'll most likely want to use the shorthand [viewModelOf] function to do
  ///so.
  static CurrentApp<T> of<T extends CurrentViewModel>(BuildContext context) {
    final CurrentApp<T>? result =
        context.dependOnInheritedWidgetOfExactType<CurrentApp<T>>();
    assert(result != null, 'No Current found in context');
    return result!;
  }

  ///Gets the [CurrentViewModel] from the [CurrentApp] that matches the generic type argument [T].
  ///
  ///This method can be called from any widget
  ///below this one in the widget tree. (Example: from a child widget):
  ///```dart
  ///Current.viewModelOf<MyApplicationViewModel>().logOut();
  ///```
  static T viewModelOf<T extends CurrentViewModel>(BuildContext context) {
    final CurrentApp<T> result = of(context);
    return result.viewModel();
  }
}

class _CurrentState<T extends CurrentViewModel> extends State<Current> {
  String? _applicationStateId;

  @override
  void initState() {
    widget.viewModel.addOnStateChangedListener((events) {
      if (widget.debugPrintStateChanges && kDebugMode) {
        // ignore: avoid_print
        events.forEach(print);
      }
      if (mounted) {
        setState(() {
          _applicationStateId = widget.onAppStateChanged();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CurrentApp<T>(
      _applicationStateId,
      viewModel: <E extends CurrentViewModel>() => widget.viewModel as E,
      child: Builder(builder: (context) {
        return widget.child;
      }),
    );
  }
}
