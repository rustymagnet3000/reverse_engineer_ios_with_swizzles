#include "swizzleHelper.h"

@implementation NSURL (YDSwizzleNSURL)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL orig = @selector(initWithString:);
        SEL swiz = @selector(YDHappyinitWithString:);
        __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:targetNSURLToSwizzle Original:orig Swizzle:swiz];

    });
}

- (instancetype)YDHappyinitWithString:(NSString *)string{
    NSLog(@"🍭NSURL request: %@", string);
    return [self YDHappyinitWithString: string];
}

@end
