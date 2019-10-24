#include "swizzleHelper.h"

@implementation NSURL (YDSwizzleNSURL)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL orig = @selector(initWithString:);
        SEL swiz = @selector(YDHappyURLInspector:);
        SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:targetNSURLToSwizzle Original:orig Swizzle:swiz];

        if (swizzle != NULL){
            NSLog(@"%@", [swizzle getDescription]);
        }
    });
}

- (instancetype)YDHappyURLInspector:(NSString *)string{
    NSLog(@"🍭NSURL request: %@", string);
    return [self YDHappyURLInspector: string];
}

@end
