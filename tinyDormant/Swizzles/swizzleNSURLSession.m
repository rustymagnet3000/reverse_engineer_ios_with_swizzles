#include "swizzleHelper.h"

@implementation NSObject (YDSwizzleNSURLSession)
 
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL orig = @selector(URLSession:didReceiveChallenge:completionHandler:);
        SEL swiz = @selector(YDHappyChallenge:didReceiveChallenge:completionHandler:);
        __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:targetURLSessionToSwizzle Original:orig Swizzle:swiz];
    });
}

- (void)YDHappyChallenge:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    NSLog(@"🍭\tNSURLSession on: %@", [[challenge protectionSpace] host]);
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, NULL);
}

@end
