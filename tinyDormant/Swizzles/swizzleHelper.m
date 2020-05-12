#import "swizzleHelper.h"

@implementation SwizzleHelper: NSObject

- (NSString *) getDescription {
    NSString *verbose = [NSString stringWithFormat:@"🍭Swizzle:\n\tTargeted class:\t%@\n\tSuperclass:\t%@", NSStringFromClass(targetClass), NSStringFromClass(targetSuperClass)];
    return verbose;
}

- (BOOL) checkClassExists {
    targetClass = objc_getClass(rawTargetClass);
    if (targetClass == NULL) {
        NSLog(@"\t🍭Stopped swizzle. Could not find %s class", rawTargetClass);
        return FALSE;
    }
    NSLog(@"🍭Swizzle started for class: %@", NSStringFromClass(targetClass));
    return TRUE;
}

- (BOOL) preSwap {
    if (originalMethod != NULL && swizzledMethod != NULL)
        return TRUE;
    
    NSLog(@"🍭Swizzle failed:\n\t%@,\n\toriginalMethod:  %p\n\tswizzledMethod: %p\n\tSwizzle failed on selector: %@", NSStringFromClass(targetClass), originalMethod, swizzledMethod, NSStringFromSelector(originalSelector));
    
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
        
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
        NSLog(@"🍭method_exchange called:[%@ %@]", NSStringFromClass(targetClass), NSStringFromSelector(originalSelector));
        return TRUE;
    }
}

- (BOOL) verifyMethodSwizzle {
    if ([targetClass respondsToSelector:replacementSelector] == TRUE){
        NSLog(@"🍭Swizzle placed.\t🏁selector responded[%@ %@]", NSStringFromClass(targetClass),NSStringFromSelector(replacementSelector));
        return TRUE;
    }
    NSLog(@"🍭Swizzle failed. 🏁Selector did not respond: %d", [targetClass respondsToSelector:replacementSelector]);
    return FALSE;
}


- (id) initWithTargets: (const char *)target
              Original:(SEL)orig
               Swizzle:(SEL)swiz {
    
    self = [super init];
    if (self) {
        
        rawTargetClass = target;
        
        if ([self checkClassExists] == FALSE)
            return NULL;
        
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
