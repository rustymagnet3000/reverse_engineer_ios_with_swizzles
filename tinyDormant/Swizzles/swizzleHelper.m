#import "swizzleHelper.h"

@implementation SwizzleHelper: NSObject

- (NSString *) getDescription {
    NSString *verbose = [NSString stringWithFormat:@"🍭Swizzle:\n\tTargeted class:\t%@\n\tSuperclass:\t%@", NSStringFromClass(targetClass), NSStringFromClass(targetSuperClass)];
    return verbose;
}

- (BOOL) preSwap {
    if (originalMethod != NULL && swizzledMethod != NULL)
        return TRUE;
    
    NSLog(@"🍭preSwap check failed. Class: %@, originalMethod:  %p swizzledMethod: %p \n", NSStringFromClass(targetClass), originalMethod, swizzledMethod);
    return FALSE;
}

- (BOOL) swapMethods {
    
    BOOL didAddMethod = class_addMethod(targetClass,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        NSLog(@"🍭didAddMethod:[%@ %@]", NSStringFromClass(targetClass), NSStringFromSelector(originalSelector));
        class_replaceMethod(targetClass,
                            replacementSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        return TRUE;
        
    } else if (originalMethod != NULL && swizzledMethod  != NULL) {
        method_exchangeImplementations(originalMethod, swizzledMethod);
        NSLog(@"🍭method_exchange called:[%@ %@]", NSStringFromClass(targetClass), NSStringFromSelector(originalSelector));
        return TRUE;
    
    }else {
        NSLog(@"🍭Swizzle FAILED");
        return FALSE;
    }
}

- (BOOL) verifyMethodSwizzle {
    if ([targetClass respondsToSelector:replacementSelector] == TRUE){
        NSLog(@"🍭Swizzle placed.\n\t%@\t🏁selector responded", NSStringFromSelector(replacementSelector));
        return TRUE;
    }
    NSLog(@"🍭Swizzle FAILED. 🏁selector did not respond");
    return FALSE;
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
        
        if ([self preSwap] == FALSE)
            return NULL;
        
        if ([self swapMethods] == FALSE)
            return NULL;

        if ([self verifyMethodSwizzle] == FALSE)
            return NULL;
    }
    return self;
}
@end
