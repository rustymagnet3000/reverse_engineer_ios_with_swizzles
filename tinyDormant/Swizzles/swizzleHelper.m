#import "swizzleHelper.h"

@implementation SwizzleHelper: NSObject

- (NSString *) getDescription {
    NSString *verbose = [NSString stringWithFormat:@"🍭Swizzle:\n\tTargeted class:\t%@\n\tSuperclass:\t%@", NSStringFromClass(targetClass), NSStringFromClass(targetSuperClass)];
    return verbose;
}

- (BOOL) verifySwap {
    
    if ([targetClass respondsToSelector:replacementSelector] == true){
        NSLog(@"🍭Swizzled.\n\t%@\n\t🏁selector responded", NSStringFromSelector(replacementSelector));
    }
    return false;
}

- (void) swapMethods {
    
    BOOL didAddMethod = class_addMethod(targetClass,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        NSLog(@"🍭didAddMethod: %@ && Class: %@", NSStringFromSelector(originalSelector), NSStringFromClass(targetClass));
        
        class_replaceMethod(targetClass,
                            replacementSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        NSLog(@"🍭method_exchangeImplementations called on: %@", NSStringFromSelector(originalSelector));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (id) initWithTargets: (const char *)target
              Original:(SEL)orig
               Swizzle:(SEL)swiz {
    
    self = [super init];
    if (self) {
        targetClass = objc_getClass(target);
        NSLog(@"🍭Swizzle started for: %@", NSStringFromClass(targetClass));
        
        if (targetClass == NULL) {
            NSLog(@"\t🍭Stopped swizzle. Could not find %s class", target);
            return NULL;
        }
        [self getDescription];
        targetSuperClass = class_getSuperclass(targetClass);
        originalSelector = orig;
        replacementSelector = swiz;
        originalMethod = class_getInstanceMethod(targetClass, originalSelector);
        swizzledMethod = class_getInstanceMethod(targetClass, replacementSelector);
        
        if (originalMethod == NULL || swizzledMethod == NULL) {
            NSLog(@"🍭Stopped swizzle. Class: %@, originalMethod:  %p swizzledMethod: %p \n", NSStringFromClass(targetClass), originalMethod, swizzledMethod);
            return NULL;
        }
        [self swapMethods];
        [self verifySwap];
    }
    return self;
}
@end
