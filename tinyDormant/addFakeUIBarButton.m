#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation UIViewController (YDFakeUIBarButton)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        Class MandalorianClass = objc_getClass("tinyDormant.YDMandalorianVC");
        Class SithClass = objc_getClass("tinyDormant.YDSithVC");

        SEL originalSelector = @selector(viewDidAppear:);
        SEL swizzledSelector = @selector(YDviewDidAppear:);
        NSLog(@"[+] 🎢 Started...");
        NSLog(@"[+] \tOriginal selector: \"%@\"", NSStringFromSelector(originalSelector));
        NSLog(@"[+] \tReplacement selector: \"%@\"", NSStringFromSelector(swizzledSelector));
        
        if (MandalorianClass != nil && SithClass != nil) {
            Class mySuperClass = class_getSuperclass(MandalorianClass);
            NSLog(@"[+] 🌠 Class: %@ && Superclass: %@", NSStringFromClass(MandalorianClass), NSStringFromClass(mySuperClass));
            
            Method original = class_getInstanceMethod(MandalorianClass, originalSelector);
            Method replacement = class_getInstanceMethod(SithClass, swizzledSelector);
            
            if (original == nil || replacement == nil) {
                NSLog(@"[+] 🎢 Problem finding Original: %p OR Replacement: %p", original, replacement);
                return;
            }

            BOOL didAddMethod =
            class_addMethod(MandalorianClass,
                            originalSelector,
                            method_getImplementation(replacement),
                            method_getTypeEncoding(replacement));
            
            if (didAddMethod) {
                NSLog(@"[+] 🌠 didAddMethod: %@ && Class: %@", NSStringFromSelector(originalSelector), NSStringFromClass(MandalorianClass));
                
                class_replaceMethod(MandalorianClass,
                                    swizzledSelector,
                                    method_getImplementation(original),
                                    method_getTypeEncoding(original));
            } else {
                NSLog(@"[+] 🌠 Method swap: %@", NSStringFromSelector(originalSelector));
                method_exchangeImplementations(original, replacement);
            }
        }
    });
}

#pragma mark - add Fake UIBarButton
- (void)YDviewDidAppear:(BOOL)animated {
    // this log shows if you have a problem with the Inheritance tree.
    NSLog(@"[+] 🌠🌠🌠 Swizzled code running.  YDviewDidAppear called from: %@ || Superclass %@", self, [self superclass]);

    [self YDviewDidAppear:animated];  // call original viewDidAppear
    UIBarButtonItem *sithUibb = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(sithHijack:)];

    self.navigationItem.rightBarButtonItem = sithUibb;

}

#pragma mark - create Sith VC and then present it
-(IBAction)sithHijack:(id)sender {
    NSLog(@"[+] 🧪🧪🧪 sithHijack");
    Class SithClass = objc_getClass("tinyDormant.YDSithVC");
    NSLog(@"[+] 🌠 Trying to create instance of: %@", NSStringFromClass(SithClass));
    id sithvc = class_createInstance(SithClass, 0);
    NSLog(@"[*]🌠 Created instance of: %@ at: %p", [sithvc class], sithvc);
    [self presentViewController:sithvc animated:YES completion:nil];
}

@end
