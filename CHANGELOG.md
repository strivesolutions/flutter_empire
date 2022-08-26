## 0.9.0-dev.1

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

* Update package description to make Pub analysis happy

## 0.8.2

* Various code formatting and file structure clean up
* Updated example README

## 0.8.1

* CI Workflow Updates
* Documentation Generation Changes

## 0.8.0

* Initial library launch


