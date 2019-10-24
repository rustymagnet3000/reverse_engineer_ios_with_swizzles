#include "swizzleHelper.h"
// Credit to: https://nshipster.com/method-swizzling/

@implementation SwizzleHelper: NSObject

@synthesize targetClass, targetSuperClass;
@synthesize originalMethod, swizzledMethod;

- (NSString *) getDescription {
    NSString *verbose = [NSString stringWithFormat:@"🍭Swizzle:\n\tTargeted class:\t%@\n\tSuperclass:\t%@", NSStringFromClass(targetClass), NSStringFromClass(targetSuperClass)];
    return verbose;
}

- (BOOL) swapMethods {
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    
    if (originalMethod == NULL || swizzledMethod == NULL) {
            NSLog(@"🍭\tStopped swizzle. originalMethod:  %p swizzledMethod: %p \n", originalMethod, swizzledMethod);
            return NO;
    }
    return YES;
}

- (id) initWithTargets: (const char *)target
              Original:(SEL)orig
               Swizzle:(SEL)swiz {
    NSLog(@"🍭Swizzle setup started...");
    self = [super init];
    if (self) {
        [self setTargetClass: objc_getClass(target)];
        if (targetClass == NULL) {
            NSLog(@"\t🍭Stopped swizzle. Could not find %s class", target);
            return NULL;
        }
        [self setOriginalSelector: orig];
        [self setReplacementSelector: swiz];
        [self setTargetSuperClass: class_getSuperclass([self targetClass])];
        [self setOriginalMethod: class_getInstanceMethod(targetClass, orig)];
        [self setSwizzledMethod: class_getInstanceMethod(targetClass, swiz)];

        if ([self swapMethods] == NO) {
            return NULL;
        }
    }
    return self;
}
@end
