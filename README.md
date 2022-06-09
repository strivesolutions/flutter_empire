
<p align="center">
    <img src="./images/EmpireLogoMD.png"/>
</p>

<h1 align="center">EMPIRE</h1>
<h3 align="center">A simple, lightweight state management library for Flutter</h3>


## Features

A Model-View-ViewModel (MVVM) approach to state management. Less boiler plate and significantly reduced clutter in your Widget build functions than other state management solutions. 


## Usage

A simple example using the classic Flutter Counter App.

### counter_view_model.dart

```dart
class CounterViewModel extends EmpireViewModel {
  late final EmpireProperty<int> count;

  @override
  void initProperties() {
    count = createProperty(0, propertyName: 'count');
  }

  Future<void> incrementCounter() async {
    count(count.value + 1);
  }
}
```

### counter_page.dart

```dart
class CounterPage extends EmpireWidget<CounterViewModel> {
  const CounterPage({Key? key, required CounterViewModel viewModel})
      : super(key: key, viewModel: viewModel);  

  @override
  EmpireState<EmpireWidget<EmpireViewModel>, CounterViewModel> createEmpire() => _CounterPageState(viewModel);
}

class _CounterPageState extends EmpireState<CounterPage, CounterViewModel> {
  _CounterPageState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Example')),
      body: Center(
        child: Text('${viewModel.count}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

```

### main.dart

```dart
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Empire State Example',
      home: CounterPage(
        viewModel: CounterViewModel(),
      ),
    );
  }
}
```

Our business logic is clearly separated from the UI in a clean and simple way. Even in more complicated situations where, with other state management solutions, it's common to create separate classes to represent your state, with Empire this is as complicated as it gets while supporting even the most complex scenarios.

By extending `EmpireWidget` and `EmpireState` and supplying an `EmpireViewModel`, your UI will automatically update whenever an `EmpireProperty` in your view model changes.

## Application Wide State Management

What if you have application wide data that you want all your widgets to have access to at any time. Enter the `Empire` widget.

Create a ViewModel for your application:

### application_view_model.dart

```dart
class ApplicationViewModel extends EmpireViewModel {
  late final EmpireProperty<User?> loggedInUser;

  @override
  void initProperties() {
    loggedInUser = createProperty(null);
  }

  void updateUser(User user) => loggedInUser(user);
}
```

Make the child of your `CupertinoApp` or `MaterialApp` an `Empire` widget. Supply a function to generate a unique application state id. This tells your app it needs to refresh the widget tree below your your `Empire` widget. In this example, we are using the [Uuid](https://pub.dev/packages/uuid) package to handle creating a unique ID. This function will get called anytime the `loggedInUser` property is changed in the `ApplicationViewModel` and trigger the UI for your app to update.

### main.dart
```dart
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Empire(
        ApplicationViewModel(),
        onAppStateChanged: () => const Uuid().v1(),
        child: Builder(
          builder: (context) {              
            final appViewModel = Empire.viewModelOf<ApplicationViewModel>(context);
            final loggedInUser = appViewModel.loggedInUser;

            return Column(
              children: [
                Text('User: ${loggedInUser}'),
                TextButton(
                  child: Text('Update User'),
                  onPressed: () => appViewModel.updateUser(User('foo', 'bar')),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
```

## Additional information

This package has **ZERO** dependencies on any other packages.

Developed by:

© 2022 [Strive Business Solutions](https://www.strivebusiness.ca/)
