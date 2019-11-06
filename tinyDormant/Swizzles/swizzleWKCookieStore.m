#include "swizzleHelper.h"
#import <WebKit/WebKit.h>

@implementation WKHTTPCookieStore (YDSwizzleWKCookieStore)
 
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL orig = @selector(setCookie:completionHandler:);
        SEL swiz = @selector(YDsetCookie:completionHandler:);
        __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:"WKHTTPCookieStore" Original:orig Swizzle:swiz];
    });
}

- (void)YDsetCookie:(NSHTTPCookie *)cookie completionHandler:(void (^)(void))completionHandler;{
    NSLog(@"🍭\tCookie: %@ | Domain: %@ | Path: %@", cookie.name, cookie.domain, cookie.path);
    [self YDsetCookie: cookie completionHandler:(void (^)(void))completionHandler];
}

@end
