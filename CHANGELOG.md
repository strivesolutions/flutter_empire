## 1.2.0

- Verify during EmpireWidget initialization that the EmpireViewModel being used has not been associated with another EmpireWidget.
  - This is a BREAKING CHANGE. Decided to do this to prevent users from introducing very difficult bugs to diagnose. See [Issue #95](https://github.com/strivesolutions/flutter_empire/issues/95)

## 1.2.0

- Verify during EmpireWidget initialization that the EmpireViewModel being used has not been associated with another EmpireWidget.
  - This is a BREAKING CHANGE. Decided to do this to prevent users from introducing very difficult bugs to diagnose. See [Issue #95](https://github.com/strivesolutions/flutter_empire/issues/95)

## 1.1.0

- Added new insert methods to EmpireListProperty: `insert, insertAll, sublist, insertAtEnd`
- Added toString override to EmpireListProperty to better show what an EmpireListProperty is when logging

## 1.0.0

First official stable release! 🎉

## 0.12.0

- Added new optional argument on EmpireProperty called `setAsOriginal`. Setting this to true will update the original value on change.
- Updated some stale documentation

## 0.11.0

- Fixed the a bug where the `busy` property on an EmpireViewModel returned an incorrect value if there are multiple different busyTaskKeys assigned.
- Added additional functionality to `EmpireListProperty` to bring them closer in line with a plain Dart List object. The following has been added:
  - `first` (read-only property)
  - `last` (read-only property)
  - `reversed` (read-only property)
  - `single` (read-only property)
  - `where` (function)
  - `firstWhere` (function)
  - `firstWhereOrNull` (function)

**BREAKING CHANGES**

We found some issues with the arithmetic operator overrides in the `EmpireIntProperty` and `EmpireDoubleProperty` classes. For details on the issue, please see [GitHub Issue #83](https://github.com/strivesolutions/flutter_empire/issues/83). Ultimately, we had to scrap the operator overrides and implement the arithmetic operations as functions.

- Implemented arithmetic functions for EmpireIntProperty and EmprieDoubleProperty, and their nullable variants
- Removed the operator overrides

We have also made changes to the constructor signature for `EmpireNullableDateTimeProperty` and `EmpireNullableIntProperty`. This was to bring them in line with the other Empire Nullable properties.

- Updated EmpireNullableDateTimeProperty and EmpireNullableIntProperty constructors so the value argument is optional instead of a required positional argument.

## 0.10.0

- Added `resetAll` function to `EmpireViewModel`. This will reset all tracked properties to their original value and trigger a UI update.

## 0.9.1

- Updated README to reflect the new `empireProps` change in the 0.9.0 release.

## 0.9.0

- Added `increment` and `decrement` functions to the `EmpireIntProperty`
- Updated the example project
- Updated README to reflect the property initialization refactor changes
- Added many factory constructors to various Empire Properties. (eg) EmpireDateTimeProperty.now() to create a DateTime property defaulted to the current Date/Time

**BREAKING CHANGES**

- We've redesigned and refactored how you go about initializing an EmpireProperty, and made it more dart-ly (it's a word now).
- Empire Properties in an EmpireViewModel are no longer initialized via a initProperties function that previously needed to be overridden, and was called by the ViewModel constructor behind the scenes. You can now instantiate a property as you would any other Dart object; via it's own constructor.
- There is a new getter List property called `empireProps` that must be overridden in a ViewModel. This should return the Empire Properties that you want to be reactive. (eg) Update the UI on change.
- This change also allowed us to remove the requirement that all Empire Properties be defined with the late keyword.
- This change also allows consumers to inject Empire Properties into the ViewModel.
- Reorganized the library exports

In general, we will avoid major breaking changes if at all possible. In this case, as we approach a stable 1.0.0 release, we felt it was an overall improvement to the library based on valuable user feedback.

## 0.9.0-dev.3

- Changed `props` to `empireProps` on `EmpireViewModel` to prevent naming clashes with other popular packages (eg) Equatable
- Added better exception handling/messaging if you forget to add a property to the `empireProps` list and try to update the property value.

## 0.9.0-dev.2

- Fixed issue where EmpireIntProperty `increment` and `decrement` functions were not updating the UI
- Updated README to reflect the property initialization refactor changes

## 0.9.0-dev.1

- Added `increment` and `decrement` functions to the `EmpireIntProperty`

**BREAKING CHANGES**

- We've redesigned and refactored how you go about initializing an EmpireProperty, and made it more dart-ly(it's a word now).

- Empire Properties in an EmpireViewModel are no longer initialized via a initProperties function that previously needed to be overridden, and was called by the ViewModel constructor behind the scenes. You can now instantiate a property as you would any other Dart object; via it's own constructor.
- This change also allowed us to remove the requirement that all Empire Properties be defined with the late keyword.
- This change also allows consumers to inject Empire Properties into the ViewModel.
- There is a new getter List property called props that must be overridden in a ViewModel. This should return the Empire Properties that you want to be reactive. (eg) Update the UI on change.
- We've also added many factory constructors to various Empire Properties. (eg) EmpireDateTimeProperty.now() to create a DateTime property defaulted to the current Date/Time
- Reorganized the library exports
- Updated the example project

## 0.8.3

- Update package description to make Pub analysis happy

## 0.8.2

- Various code formatting and file structure clean up
- Updated example README

## 0.8.1

- CI Workflow Updates
- Documentation Generation Changes

## 0.8.0

- Initial library launch
