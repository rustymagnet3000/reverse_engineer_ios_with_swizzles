#import "swizzleHelper.h"

@implementation SwizzleHelper: NSObject

- (NSString *) getDescription {
    NSString *verbose = [NSString stringWithFormat:@"🍭Swizzle:\n\tTargeted class:\t%@\n\tSuperclass:\t%@", NSStringFromClass(targetClass), NSStringFromClass(targetSuperClass)];
    return verbose;
}

- (BOOL) checkClassExists {
    targetClass = objc_getClass(rawTargetClass);
    if (targetClass == NULL) {
        NSLog(@"\t🍭❌Stopped swizzle. Could not find %s class", rawTargetClass);
        return NO;
    }
    NSLog(@"🍭Found class: %@", NSStringFromClass(targetClass));
    return YES;
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
        return YES;
        
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
        NSLog(@"🍭method_exchange called:[%@ %@]", NSStringFromClass(targetClass), NSStringFromSelector(originalSelector));
        return YES;
    }
}

- (BOOL) verifySwap {
    if ([targetClass respondsToSelector:replacementSelector] == TRUE){
        NSLog(@"🍭Swizzle placed.\t🏁selector responded[%@ %@]", NSStringFromClass(targetClass),NSStringFromSelector(replacementSelector));
        return YES;
    }
    NSLog(@"🍭❌Swizzle failed. 🏁Selector did not respond: %d", [targetClass respondsToSelector:replacementSelector]);
    return NO;
}


-(BOOL) getMethodPointers{
    if ([targetClass respondsToSelector:originalSelector]){
        NSLog(@"🍭Selector responded as a Class Method");
        targetClass = object_getClass((id)targetClass);
        originalMethod = class_getClassMethod(targetClass, originalSelector);
        swizzledMethod = class_getClassMethod(targetClass, replacementSelector);
    }
    if ([targetClass instancesRespondToSelector:originalSelector]){
        NSLog(@"🍭Selector responded as a Instance Method");
        originalMethod = class_getInstanceMethod(targetClass, originalSelector);
        swizzledMethod = class_getInstanceMethod(targetClass, replacementSelector);
    }
    
    if (originalMethod != NULL && swizzledMethod != NULL)
        return YES;
    
    NSLog(@"🍭❌%@:%@  did not respond", NSStringFromClass(targetClass), NSStringFromSelector(originalSelector));
    NSLog(@"\t\t🍭❌Swizzle failed:\n\t%@,\n\toriginalMethod:  %p\n\tswizzledMethod: %p\n\tSwizzle failed on selector: %@", NSStringFromClass(targetClass), originalMethod, swizzledMethod, NSStringFromSelector(originalSelector));
    return NO;
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
        
        if ([self getMethodPointers] == FALSE)
            return NULL;
        
        if ([self swapMethods] == FALSE)
            return NULL;

        if ([self verifySwap] == FALSE)
            return NULL;
    }
    return self;
}
@end

