<p align="center">
    <img src="https://github.com/strivesolutions/flutter_empire/raw/main/images/EmpireLogoMD.png"/>
</p>

<h1 align="center">EMPIRE</h1>
<h3 align="center">A simple, lightweight state management library for Flutter</h3>

## Features

A Model-View-ViewModel (MVVM) like approach to state management. Less boiler plate and significantly reduced clutter in your Widget build functions than other state management solutions.

## Getting Started

In your flutter project, add the dependency to your `pubspec.yaml`

```yaml
  dependencies:
    empire: ^0.8.1
```

## Usage

A simple example using the classic Flutter Counter App.

### counter_view_model.dart

```dart

import 'package:empire/empire_view_model.dart';
import 'package:empire/empire_property.dart';

class CounterViewModel extends EmpireViewModel {
  late final EmpireIntProperty count;

  @override
  void initProperties() {
    count = createIntProperty(0, propertyName: 'count');
  }

  Future<void> incrementCounter() async {
    count(count.value + 1);
  }
}
```

### counter_page.dart

```dart
import 'package:empire/empire.dart';

class CounterPage extends EmpireWidget<CounterViewModel> {
  const CounterPage({super.key, required super.viewModel});

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
  const MyApp({super.key});

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
import 'package:empire/empire_property.dart';

class ApplicationViewModel extends EmpireViewModel {
  late final EmpireProperty<User?> loggedInUser;

  @override
  void initProperties() {
    loggedInUser = createNullProperty();
  }

  void updateUser(User user) => loggedInUser(user);
}
```

Make the child of your `CupertinoApp` or `MaterialApp` an `Empire` widget. Supply a function to generate a unique application state id. This tells your app it needs to refresh the widget tree below your your `Empire` widget. In this example, we are using the [Uuid](https://pub.dev/packages/uuid) package to handle creating a unique ID, but we leave it up to you to decide what dependencies you want to include in your application. This function will get called anytime the `loggedInUser` property is changed in the `ApplicationViewModel` and trigger the UI for your app to update.

### main.dart

```dart
import 'package:empire/empire.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

## Contributing

This is an open source project, and thus contributions to this project are welcome - please feel free to [create a new issue](https://github.com/strivesolutions/flutter_empire/issues/new/choose) if you encounter any problems, or [submit a pull request](https://github.com/strivesolutions/flutter_empire/pulls). For community contribution guidelines, please reveiw the [Code of Conduct](CODE_OF_CONDUCT.md).

If submitting a pull request, please ensure the following standards are met:

1) Code files must be well formatted (run `flutter format .`). 

2) Tests must pass (run `flutter test`).  New test cases to validate your changes are highly recommended.

3) Implementations must not add any project dependencies. 

4) Project must contain zero warnings. Running `flutter analyze` must return zero issues.

5) Ensure docstrings are kept up-to-date. New feature additions must include docstrings.

## Additional information

This package has **ZERO** dependencies on any other packages.

You can find the full API documentation [here](https://strivesolutions.github.io/flutter_empire/empire/empire-library.html)

Developed by:

© 2022 [Strive Business Solutions](https://www.strivebusiness.ca/)
