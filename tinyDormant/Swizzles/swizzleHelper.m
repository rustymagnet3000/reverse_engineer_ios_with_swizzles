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
    if ([targetClass respondsToSelector:replacementSelector] == YES){
        NSLog(@"🍭Swizzle placed.\t🏁selector responded [%@ %@]", NSStringFromClass(targetClass),NSStringFromSelector(replacementSelector));
        return YES;
    }
    NSLog(@"🍭❌🏁Selector did NOT respond [%@ %@]", NSStringFromClass(targetClass),NSStringFromSelector(replacementSelector));
        NSLog(@"\t\t🍭❌Failed:\n\t%@,\n\t🍭originalMethod:  %p\n\t🍭swizzledMethod: %p\n\t🍭Swizzle failed on selector: %@", NSStringFromClass(targetClass), originalMethod, swizzledMethod, NSStringFromSelector(originalSelector));
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

    if(originalMethod == NULL){
        NSLog(@"🍭❌Can't find target method: [%@ %@]", NSStringFromClass(targetClass), NSStringFromSelector(originalSelector));
        return NO;
    }
    
    if(swizzledMethod == NULL){
        NSLog(@"🍭❌Can't find the replacement code: %@",  NSStringFromSelector(replacementSelector));
        return NO;
    }
    
    return YES;
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
        
        if ([self getMethodPointers] == NO)
            return NULL;
        
        if ([self swapMethods] == NO)
            return NULL;

        if ([self verifySwap] == NO)
            return NULL;
    }
    return self;
}
@end


