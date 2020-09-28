#include "swizzleHelper.h"

/*  This works for UIWebView or NSURLSessioy.
    The below trace works on physical iOS devices but NOT iOS Simulators with WKWebView.
 
 Refer to here for how to get Cookies from WKWebView: https://github.com/rustymagnet3000/debugger_playground/tree/master/4b_NSHTTPCookie_thief
 
 frida-trace -m "*[NSHTTPCookie *]" -p $myapp
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

    NSLog(@"🍭Cookie properties: %@", properties);
    return [self YDinitWithProperties:(NSDictionary<NSHTTPCookiePropertyKey, id> *)properties];
}

@end
