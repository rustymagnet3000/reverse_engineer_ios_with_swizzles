# Tiny Swizzle
### Background
The `TinySwizzle.framework` attempted to find `Dormant` code inside an app, after you have told it what to look for.

###  Swizzling
The crux of the code loaded  `dormant ViewControllers`.  The project fired when it found a dormant `Storyboard`, a `XIB` file or a 100% code ViewController [ that did not rely on a `Storyboard` file or `XIB` file ].

### What am I looking for?
If you want to target a specific piece of `dormant` code you first perform a `Class Dump`.   Just tick the `Target Membership` box to include the  `dumpClasses.m` file inside of the iOS app's `Target`.  Then it will run the app and print the found classes.
```
[*] 🌠 Started Class introspection...
    [*]tinyDormant.AppDelegate
    [*]tinyDormant.PorgViewController
    [*]tinyDormant.YDJediVC
    [*]tinyDormant.YDSithVC
    [*]tinyDormant.YDMandalorianVC
    [*]tinyDormant.YDPorgImageView
```
### Set your Target
Set the values of the `View Controller` you want to hijack and swizzle.  
```
// The Target Swift ViewController to Swizzle
#define targetClassStr "tinyDormant.YDMandalorianVC"
```
I used a `Header file` that had `#define` statements to avoid having magic strings inside the code.
```
// A ViewController is 100% in code ( no XIB or Storyboard )
#define dormantClassStr "tinyDormant.YDSithVC"

// Dormant ViewController with a Storyboard file and ID
#define chewyClassStr "tinyDormant.YDChewyVC"
#define chewyStoryboardID "chewyStoryboardID"
#define chewyStoryboardFile "Main"

// Dormant ViewController with an associated XIB file
#define dormantPorgClassStr "tinyDormant.YDPorgVC"
#define dormantXibStr "PorgViewController"
```

### Run (Simulator)
Now get the framework into your app.  The project contained two `Targets`.  An iOS app and a simple framework.  The app just demonstrated what the Swizzle framework could do.  This app worked with a Simulator or real device. 

### Run (device with real app)
The framework could be repackaged inside of a real iOS app.  The process was summarised as :
```
- Unzipping the IPA
- Adding the Swizzle framework
- Adding a load command, so the app knew to load the new framework
- Zipping the app contents
- Code signing the modified IPA
```
The commands were as follows:
```
optool install -c load -p "@executable_path/Frameworks/tinySwizzle.framework/tinySwizzle" -t Payload/MyApp.app/MyApp
jtool -arch arm64 -l Payload/MyApp.app/MyApp
7z a unsigned.ipa Payload
applesign -7 -i < DEV CODE SIGNING ID > -m embedded.mobileprovision unsigned.ipa -o ready.ipa
```
### Goal: unlock Dormant code
The Swizzle code inside of `addFakeUIBarButton.m` added a `UIBarButton` to make it clear the code had executed.  Once you selected the button it loaded the dormant class.


### Explaining the code
The Swizzle used the Objective-C `runtime.h` APIs from Apple.  Namely:

- [x]  class_addMethod
- [x]  class_replaceMethod
- [x]  method_exchangeImplementations
- [x]  objc_getClass


The `Sith` ViewController was 100% code generated.  It did not rely on a reference inside of `Main.Storyboard` or an XIB file. So I used this API to create it:
```
Class SithClass = objc_getClass(dormantClassStr);
id sithvc = class_createInstance(SithClass, 0);
```
After you select the `UIBarButton` it loads the `ViewController`.

![sith](tinyDormant/readme_images/sith.png)

But to invoke the `PorgViewController` you need to find the `ViewController and` the `XIB` file.  Then you can run this line:
```
let porgvc = YDPorgVC(nibName: "PorgViewController", bundle: nil)
```
Notice how you use the ViewController (`YDPorgVC`) to cast the XIB file.  After that, you can choose what option you want to show the code.
```
self.navigationController?.pushViewController(porgvc, animated: true)
```

![porg](tinyDormant/readme_images/porg.png)

### What next?
This worked on Objective-C and Swift code.  

- I only tried with Swift code that inherits from `NSObject`.
- Not tried this `SwiftUI`.
