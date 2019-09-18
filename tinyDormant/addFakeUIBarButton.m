#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#include "staticStrings.h"

@interface YDFakeUIBarButton : UIViewController {
    NSString *_sbClass;
    NSString *_sbID;
    NSString *_sbFile;
}
@property NSString *sbClass, *sbID, *sbFile;
@end

@implementation YDFakeUIBarButton


+ (void)load
{

    NSLog(@"🍭\t[+]load  (YDFakeUIBarButton)");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        Class MandalorianClass = objc_getClass(targetClassStr);
        Class SithClass = objc_getClass(dormantClassStr);
        
        SEL originalSelector = @selector(viewDidAppear:);
        SEL swizzledSelector = @selector(YDviewDidAppear:);
        NSLog(@"[+] 🎢 Started...");
        NSLog(@"[+] \tOriginal selector: \"%@\"", NSStringFromSelector(originalSelector));
        NSLog(@"[+] \tReplacement selector: \"%@\"", NSStringFromSelector(swizzledSelector));
        
        if (MandalorianClass != nil && SithClass != nil) {
            Class mySuperClass = class_getSuperclass(MandalorianClass);
            NSLog(@"[+] 🌠 Inside object: %@ ", [self class]);
            NSLog(@"[+] 🌠 Class: %@ && Superclass: %@", NSStringFromClass(MandalorianClass), NSStringFromClass(mySuperClass));
            
            Method original = class_getInstanceMethod(MandalorianClass, originalSelector);
            Method replacement = class_getInstanceMethod(SithClass, swizzledSelector);
            
            if (original == nil || replacement == nil) {
                NSLog(@"[+] 🎢 Problem finding Original: %p OR Replacement: %p", original, replacement);
                return;
            }

            BOOL didAddMethod = class_addMethod(MandalorianClass,
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

#pragma mark - add navigationItem UIBarButtons
- (void)YDviewDidAppear:(BOOL)animated {

    [self YDviewDidAppear:animated];

    // log identifies if a problem with Inheritance
    NSLog(@"[+] 🌠🌠🌠 Swizzled. YDviewDidAppear called from: %@", self);
    self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    
    NSString *swizzleplist = @"YDSwizzlePlist";
    NSLog(@"🍭\tAttmepting to read: %@", swizzleplist);
    
    NSString *fwPath = [[[NSBundle mainBundle] privateFrameworksPath] stringByAppendingPathComponent:@"tinySwizzle.framework"];
    NSBundle *bundle = [NSBundle bundleWithPath:fwPath];
    NSString *file = [bundle pathForResource:swizzleplist ofType:@"plist"];
    NSArray *heroes = [NSArray arrayWithContentsOfFile:file];
    
    if (heroes == NULL || bundle == NULL || file == NULL) {
        NSLog(@"🍭\tCan't find framework, swizzle plist file or the data inside the plist");
        return;
    }

    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    for (id hero in heroes) {
        NSLog(@"\t Hero : %@", hero);
        
        UIBarButtonItem *sbBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(storyboardHijack:andSecond:)];
        [buttons addObject:sbBarButton];
    }
    self.navigationItem.leftBarButtonItems = buttons;
    
    UIBarButtonItem *sithBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(sithHijack:)];
    
    UIBarButtonItem *porgBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(porgHijack:)];
    
    self.navigationItem.rightBarButtonItems =@[porgBarButton, sithBarButton];
    
}

#pragma mark - the View Controller that is not tied to a XIB or Storyboard
-(IBAction)sithHijack:(id)sender {
    NSLog(@"[+] 🧪🧪🧪 sithHijack");
    Class SithClass = objc_getClass(dormantClassStr);
    NSLog(@"[+] 🐸 Trying to create instance of: %@", NSStringFromClass(SithClass));
    id sithvc = class_createInstance(SithClass, 0);
    NSLog(@"[+] 🐸 Created instance of: %@ at: %p", [sithvc class], sithvc);
    NSLog(@"[+] 🐸 In class: %@ with Superclass: %@", [self class], [self superclass]);
    NSLog(@"[+] 🐸 Self navigationController: %@", [self navigationController]);
    NSLog(@"[+] 🐸 Self tabBarController: %@", [self tabBarController]);
    [[self navigationController] pushViewController:sithvc animated:YES];
}

#pragma mark - the Nib file and View Controller
-(IBAction)porgHijack:(id)sender {

    Class PorgClass = objc_getClass(dormantPorgClassStr);
    NSLog(@"[+] 🐸 Trying to create instance of: %@", NSStringFromClass(PorgClass));
    id porgvc = class_createInstance(PorgClass, 0);
    [[NSBundle mainBundle] loadNibNamed:@dormantXibStr owner:porgvc options:nil];
    [[self navigationController] pushViewController:porgvc animated:YES];
}

#pragma mark - the Storyboard file and View Controller
-(IBAction)chewyHijack:(id)sender {
    NSLog(@"[+] 🧪🧪🧪 chewyHijack");
    Class ChewyClass = objc_getClass(chewyClassStr);
    NSLog(@"[+] 🐸 Trying to create instance of: %@", NSStringFromClass(ChewyClass));
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@chewyStoryboardFile bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@chewyStoryboardID];
    [[self navigationController] pushViewController:vc animated:YES];

}

-(IBAction)hanHijack:(id)sender {
    NSLog(@"[+] 🧪🧪🧪 hanHijack");
    Class SoloClass = objc_getClass(soloClassStr);
    NSLog(@"[+] 🐸 Trying to create instance of: %@", NSStringFromClass(SoloClass));
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@soloStoryboardFile bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@soloStoryboardID];
    [[self navigationController] pushViewController:vc animated:YES];
    
}

-(IBAction)bobaHijack:(id)sender {
    NSLog(@"[+] 🧪🧪🧪 bobaHijack");
    Class BobaClass = objc_getClass(bobaClassStr);
    NSLog(@"[+] 🐸 Trying to create instance of: %@", NSStringFromClass(BobaClass));
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@bobaStoryboardFile bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@bobaStoryboardID];
    [[self navigationController] pushViewController:vc animated:YES];
    
}

-(IBAction)     storyboardHijack:(id)sender
                andSecond:(id) stDetails
{
    NSLog(@"[+] 🧪🧪🧪 storyboardHijack invoked by: %@", [sender class]);
    NSLog(@"[+] 🧪🧪🧪 storyboard Details: %@", stDetails);
}
@end
