# Tiny Swizzle
### Background
The `TinySwizzle.framework` finds _Dormant_ `Swift` or `ObjC` iOS code.
### Setup
Clone the repo.  Create a `YDSwizzlePlist.plist` file.  Check the `Target Membership` tickbox.  This must be ticked so the plist file ships inside the framework. An example plist:
```
<plist version="1.0">
    <array>
        <dict>
            <key>storyboardClassName</key>
            <string>tinyDormant.YDChewyVC</string>
            <key>storyboardID</key>
            <string>chewyStoryboardID</string>
            <key>storyboardFile</key>
            <string>Main</string>
        </dict>
    </array>
</plist>
```

###  Swizzling
The swizzle could invoke `dormant ViewControllers` from three places:
1. Storyboard files (or a single Main.storyboard)
2. A `XIB` file
3. A 100% code-only ViewController

### Find your Class
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
The above print was for a Swift app. Notice you need the Module name, when writing a Swift class, unlike Objective-C.

Credit to: https://nshipster.com/method-swizzling/ for an excellent article.

### Find Method
To swizzle successfully, you need the correct `Selector` name.  Remember the colons are important, with `ObjC` and these may or may not include mention of the associated class.  Get these Method signatures from `Xcode Developer Documentation`.

```
@selector(webView:didReceiveAuthenticationChallenge:completionHandler:);        // WKWebView Auth Challenge
@selector(URLSession:didReceiveChallenge:completionHandler:);                   // NSURLSession Auth Challenge
@selector(initWithProperties:);                                                 // NSHTTPCookie
```

### Find Property
You can  use `Method Swizzle` on  `Properties`.  Although normally internal calls / removed from `Developer Documents`, you can trace or use a debugger to find the `getter` and `setter`. 

For example, I found the `WKWebView Class` set the `Navigation Delegate` [ the bit of code that let's the develop to re-use boiler plate code from Apple ] with these commands:

```
 (lldb) lookup setNavigationDe
 ****************************************************
 2 hits in: WebKit
 ****************************************************
 -[WKWebView setNavigationDelegate:]

 WebKit::NavigationState::setNavigationDelegate(id<WKNavigationDelegate>)
 
 (lldb) b -[WKWebView setNavigationDelegate:]

 // breakpoint fires

 (lldb) po $arg1
 <WKWebView: 0x7f8e90875400; frame = (0 0; 0 0); layer = <CALayer: 0x600000fdfb20>>

 (lldb) p (char *) $arg2
 (char *) $13 = 0x00007fff51f655b3 "setNavigationDelegate:"

 (lldb) po $arg3
 <tinyDormant.YDWKViewController: 0x7f8e8f416350>
*/
```
Then I have the signature for the Swizzle and a gut fell for what is passed in each parameter:
```
SEL orig = @selector(setNavigationDelegate:);
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
### Explaining the code
The Swizzle used the Objective-C `runtime.h` APIs from Apple.  Namely:

- [x]  class_addMethod
- [x]  class_replaceMethod
- [x]  method_exchangeImplementations
- [x]  objc_getClass

Due to `Subclassing`, if you followed the StackOverflow recommendations [ and solely used `method_exchangeImplementations` ] you would create unexpected behaviour.  Take the `addFakeUIBarButton` example.  You could place the fake UIBarButtons with the `method_exchangeImplementations` without using `class_addMethod` and `class_replaceMethod`.  But the fake `viewDidLoad` got called on lots of other classes when you only targeted the  `UIViewController` class.

### Results
The `Sith` ViewController was 100% code generated. The dynamic nature of Objective-C lets you create  classes at `runtime`:
```
Class SithClass = objc_getClass(dormantClassStr);
id sithvc = class_createInstance(SithClass, 0);
```
After you select the `FakeUIBarButtonItem` it loaded the `ViewController`.

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

- A different API for swizzling: https://blog.newrelic.com/engineering/right-way-to-swizzle/
- I only tried with Swift code that inherits from `NSObject`.
- Not tried this `SwiftUI`.
