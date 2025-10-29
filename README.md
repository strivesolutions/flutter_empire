<p align="center">
    <img src="https://github.com/thirdversion/flutter_current/raw/main/images/images/CurrentLogo.png" alt="Current Logo" style="max-width: 100%; height: 125px;"/>
</p>

<h1 align="center">Flutter Current</h1>
<h3 align="center">A simple, lightweight state management library for Flutter</h3>

## Features

Less boiler plate and significantly reduced clutter in your Widget build functions than other state management solutions.

## Getting Started

In your flutter project, add the dependency to your `pubspec.yaml`

```yaml
dependencies:
  current: ^2.0.0
```

**Tip:** Consider installing the [Current Flutter Snippets](https://marketplace.visualstudio.com/items?itemName=ThirdVersionTechnology.current-flutter-snippets) extension in Visual Studio Code to make creating Current classes easier.

## Usage

A simple example using the classic Flutter Counter App.

### counter_view_model.dart

```dart

import 'package:current/current.dart';

class CounterViewModel extends CurrentViewModel {
  final count = CurrentIntProperty.zero(propertyName: 'count');

  void incrementCounter()  {
    count.increment();
  }

  @override
  List<CurrentProperty> get currentProps => [count];
}
```

### counter_page.dart

```dart
import 'package:current/current.dart';

class CounterPage extends CurrentWidget<CounterViewModel> {
  const CounterPage({super.key, required super.viewModel});

  @override
  CurrentState<CurrentWidget<CurrentViewModel>, CounterViewModel> createCurrent() => _CounterPageState(viewModel);
}

class _CounterPageState extends CurrentState<CounterPage, CounterViewModel> {
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
      title: 'Current State Example',
      home: CounterPage(
        viewModel: CounterViewModel(),
      ),
    );
  }
}
```

Our business logic is clearly separated from the UI in a clean and simple way. Even in more complicated situations where, with other state management solutions, it's common to create separate classes to represent your state, with Current this is as complicated as it gets while supporting even the most complex scenarios.

By extending `CurrentWidget` and `CurrentState` and supplying an `CurrentViewModel`, your UI will automatically update whenever an `CurrentProperty` in your view model changes.

## Application Wide State Management

What if you have application wide data that you want all your widgets to have access to at any time. Enter the `Current` widget.

Create a ViewModel for your application:

### application_view_model.dart

```dart
import 'package:current/current.dart';

class ApplicationViewModel extends CurrentViewModel {
  final loggedInUser = CurrentProperty<User?>(null);

  void updateUser(User user) => loggedInUser(user);

  @override
  List<CurrentProperty> get currentProps => [loggedInUser];
}
```

Make the child of your `CupertinoApp` or `MaterialApp` an `Current` widget. Supply a function to generate a unique application state id. This tells your app it needs to refresh the widget tree below your your `Current` widget. In this example, we are using the [Uuid](https://pub.dev/packages/uuid) package to handle creating a unique ID, but we leave it up to you to decide what dependencies you want to include in your application. This function will get called anytime the `loggedInUser` property is changed in the `ApplicationViewModel` and trigger the UI for your app to update.

### main.dart

```dart
import 'package:current/current.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Current(
        ApplicationViewModel(),
        onAppStateChanged: () => const Uuid().v1(),
        child: Builder(
          builder: (context) {
            final appViewModel = Current.viewModelOf<ApplicationViewModel>(context);
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

This is an open source project, and thus contributions to this project are welcome - please feel free to [create a new issue](https://github.com/thirdversion/flutter_current/issues/new/choose) if you encounter any problems, or [submit a pull request](https://github.com/thirdversion/flutter_current/pulls). For community contribution guidelines, please reveiw the [Code of Conduct](CODE_OF_CONDUCT.md).

If submitting a pull request, please ensure the following standards are met:

1. Code files must be well formatted (run `flutter format .`).

2. Tests must pass (run `flutter test`). New test cases to validate your changes are highly recommended.

3. Implementations must not add any project dependencies.

4. Project must contain zero warnings. Running `flutter analyze` must return zero issues.

5. Ensure docstrings are kept up-to-date. New feature additions must include docstrings.

## Additional information

This package has **ZERO** dependencies on any other packages.

You can find the full API documentation [here](https://pub.dev/documentation/current/latest/)

Developed by:

© 2025 [Third Version Technology Ltd](https://thirdversion.ca/)
