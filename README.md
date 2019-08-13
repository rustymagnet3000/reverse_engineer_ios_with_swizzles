
## Tiny Swizzle
This project contains two `Targets`.  A simple iOS app and a simple framework.  

The framework can be repackaged inside of a real iOS app.  It works on real iOS devices and iOS Simulators.

### Background
It attempts to find `Dormant` code inside an app, after you have told it what to look for.  

Find your target Classes by performing a `Class Dump`.   In this project, just tick the box to include the  `dumpClasses.m` file inside of the iOS app's `Target`.  Then it will find what you wanted:
```
[*] 🌠 Started Class introspection...
[*]tinyDormant.AppDelegate
[*]tinyDormant.PorgViewController
[*]tinyDormant.YDJediVC
[*]tinyDormant.YDSithVC
[*]🌠 FOUND SITH -> isKindOfClass!
[*]🌠 FOUND SITH -> isMemberOfClass!
```

This works on Objective-C and Swift.  I have only tried with Swift code that inherits from `NSObject`. I have not tried this with the 2019 launched `SwiftUI`.

### Method Swizzle
The crux of the example code swaps `dormant` code with real code that is running inside the target app. It works uses the Objective-C `runtime.h` APIs from Apple.  Namely:

- [x] class_addMethod
- [x]  class_replaceMethod
- [x] method_exchangeImplementations

### Run Dormant Code
The Swizzle code adds a `UIBarButton` to make it clear the code has executed.  Once you select the button it will perform one of these actions:
```
[[self navigationController] pushViewController:sithvc animated:YES];    
```
