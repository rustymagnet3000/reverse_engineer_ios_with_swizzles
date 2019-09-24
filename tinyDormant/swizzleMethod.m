#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#include "staticStrings.h"

@implementation NSObject (YDSwizzleMethod)

+ (void)load
{
    NSLog(@"🍭Constructor called for Category (YDSwizzleMethod)");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                
        Class class = objc_getClass(targetClassMethodSwizzle);
        NSLog(@"🍭Started. Found class: %@ at: %p", NSStringFromClass(class), class);
        if (class == NULL) {
            NSLog(@"🍭Stopped swizzle. Can't find Class \n");
            return;
        }
        
        SEL originalSelector = sel_registerName(targetMethodSwizzle);
        SEL swizzledSelector = @selector(XXXmethod);
        NSLog(@"🍭Searched for: \"%@\" selector", NSStringFromSelector(originalSelector));
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        if (originalMethod == NULL || swizzledMethod == NULL) {
            NSLog(@"🍭Stopped swizzle. Can't find method instances for %@ instance \n", class);
            return;
        } else {
            NSLog(@"🍭method_exchangeImplementations");
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}


- (BOOL)XXXmethod{
    NSLog(@"🍭In XXXmethod ... 🧪");
    
    BOOL realResult = NO;
    realResult = [self XXXmethod];
    
    NSLog(@"🍭True result: %@", realResult ? @"YES" : @"NO");
    if (realResult)
        NSLog(@"🍭Turning it from NO to YES");

    return YES;
}

@end
