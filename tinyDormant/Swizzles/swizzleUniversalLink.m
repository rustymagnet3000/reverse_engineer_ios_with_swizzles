#include "swizzleHelper.h"

@implementation NSObject (YDSwizzleNSApplication)
 
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL orig = @selector(application:continueUserActivity:restorationHandler:);
        SEL swiz = @selector(YDapplication:continueUserActivity:restorationHandler:);
        __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:targetDeeplinkAppDelegateToSwizzle Original:orig Swizzle:swiz];
    });
}


- (BOOL)YDapplication:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    
    NSLog(@"🍭\tSwizzled hit for restorationHandler");
    return [self YDapplication:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

@end
