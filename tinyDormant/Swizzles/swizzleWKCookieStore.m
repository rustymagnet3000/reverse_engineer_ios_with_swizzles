#include "swizzleHelper.h"
#import <WebKit/WebKit.h>

@implementation NSHTTPCookie (YDSwizzleWKCookieStore)
 
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL orig = @selector(initWithProperties:);
        SEL swiz = @selector(YDinitWithProperties:);
        __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:"NSHTTPCookie" Original:orig Swizzle:swiz];
    });
}

- (instancetype)YDinitWithProperties:(NSDictionary<NSHTTPCookiePropertyKey, id> *)properties;{
    NSLog(@"🍭\tCookie initWithProperties: %@", properties);
    return [self YDinitWithProperties:(NSDictionary<NSHTTPCookiePropertyKey, id> *)properties];
}

@end
