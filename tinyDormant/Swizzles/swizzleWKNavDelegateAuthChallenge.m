#include "swizzleHelper.h"
#import <WebKit/WebKit.h>

@implementation NSObject (YDSwizzleWKNavDelAuthChallenge)
 
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        SEL orig = @selector(webView:didReceiveAuthenticationChallenge:completionHandler:);
        SEL swiz= @selector(YDHappywebView:didReceiveAuthenticationChallenge:completionHandler:);
        __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:"tinyDormant.YDWKViewController" Original:orig Swizzle:swiz];
    });
}


- (void)YDHappywebView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler{
    
    NSLog(@"🍭WKWebView NSURLAuthenticationChallenge from: %@", [[challenge protectionSpace] host]);
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, NULL);
}

@end
