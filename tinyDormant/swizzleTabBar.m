#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...) {}
#endif

// This is an ode to: https://nshipster.com/method-swizzling/
// if you swizzle on UIViewController, viewDidAppear() is invoked twice

@implementation UITabBarController (SwizzleTB)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        NSLog(@"[+] 🌠 Started UITabBarController swizzle...");
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(YDviewWillAppear:);
        
        NSLog(@"[+] 🌠 Searching for: \"%@\" selector", NSStringFromSelector(originalSelector));
        
        if (class != nil) {
            Class mySuperClass = class_getSuperclass(class);
            NSLog(@"[+] 🌠 Found: %@ && superclass: %@", NSStringFromClass(class), NSStringFromClass(mySuperClass));
            
            Method original = class_getInstanceMethod(class, originalSelector);
            Method replacement = class_getInstanceMethod(class, swizzledSelector);
            
            BOOL didAddMethod =
            class_addMethod(class,
                            originalSelector,
                            method_getImplementation(replacement),
                            method_getTypeEncoding(replacement));
            
            if (didAddMethod) {
                class_replaceMethod(class,
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

#pragma mark - Method Swizzle

- (void)YDviewWillAppear:(BOOL)animated {
  
    NSLog(@"[+] 🌠🌠🌠 viewWillAppear called from: %@ || Superclass %@", self, [self superclass]);
    Class sithVcClass = objc_getClass("tinyDormant.YDSithVC");
    id sithvc = class_createInstance(sithVcClass, 0);
    NSLog(@"[*]🌠 Created instance of: %@ at: %p", [sithvc class], sithvc);
    
    #pragma mark - Add and Remove VC
    NSMutableArray *arrayofvc = (NSMutableArray *)[self viewControllers];
    [arrayofvc addObject:sithvc];
    [arrayofvc removeObjectAtIndex:0];
    NSUInteger sithIndex = [arrayofvc indexOfObject:sithvc];
    [self setViewControllers:arrayofvc];
    [self setSelectedViewController:sithvc];
    [[self.tabBar.items objectAtIndex:sithIndex] setBadgeValue:@"99"];
    
    UIImage *sithimage = [UIImage imageNamed:@"approval"];
    [[self.tabBar.items objectAtIndex:sithIndex] setImage:sithimage];
    [self YDviewWillAppear:animated];
}
@end

