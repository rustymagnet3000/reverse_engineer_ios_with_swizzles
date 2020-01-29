#include "swizzleHelper.h"
#import <WebKit/WebKit.h>

/* This works for UIWebView or NSURLSession.  This does not work for WKWebView
 Refer to https://github.com/rustymagnet3000/debugger_playground/tree/master/4b_NSHTTPCookie_thief for why
 */

@implementation NSObject (YDSwizzleNSHTTPCookie)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL orig = @selector(initWithProperties:);
        SEL swiz = @selector(YDinitWithProperties:);
        __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:"NSHTTPCookie" Original:orig Swizzle:swiz];
    });
}

- (instancetype)YDinitWithProperties:(NSDictionary<NSHTTPCookiePropertyKey, id> *)properties;{

    NSLog(@"🍭All Cookie properties: %@", properties);
    return [self YDinitWithProperties:(NSDictionary<NSHTTPCookiePropertyKey, id> *)properties];
}

@end
