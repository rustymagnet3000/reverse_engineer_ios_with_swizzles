#include "swizzleHelper.h"

@implementation NSURLSession (YDSwizzleNSURLSession)
 
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        SEL orig = @selector(URLSession:didReceiveChallenge:completionHandler:);
        SEL swiz = @selector(YDHappyChallenge:didReceiveChallenge:completionHandler:);
        SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:targetURLSessionToSwizzle Original:orig Swizzle:swiz];

        if (swizzle != NULL){
            NSLog(@"%@", [swizzle getDescription]);
            
        }
    });
}

- (void)YDHappyChallenge:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{

    NSLog(@"🍭\tNSURLSession on: %@", [[challenge protectionSpace] host]);
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, NULL);
}

@end
