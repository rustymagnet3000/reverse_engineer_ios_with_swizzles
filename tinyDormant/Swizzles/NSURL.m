#include "swizzleHelper.h"

@implementation NSObject (YDSwizzleNSURL)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL orig = @selector(initWithString:);
        SEL swiz = @selector(YDinitWithString:);
        __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:targetNSURLToSwizzle Original:orig Swizzle:swiz];

    });
}

- (instancetype)YDinitWithString:(NSString *)string{
    NSLog(@"🍭NSURL request: %@", string);
    return [self YDinitWithString: string];
}

@end
