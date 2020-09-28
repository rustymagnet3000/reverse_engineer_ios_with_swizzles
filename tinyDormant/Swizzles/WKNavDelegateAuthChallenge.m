#include "swizzleHelper.h"
#import "YDplistReader.h"

// MARK: Updated to deal with multiple target methods

@implementation NSObject (YDSwizzleWKNavDelAuthChallenge)
 
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *plistName = @"YDTargetClasses";
        SEL orig = @selector(webView:didReceiveAuthenticationChallenge:completionHandler:);
        SEL swiz= @selector(YDHappywebView:didReceiveAuthenticationChallenge:completionHandler:);
        
        YDplistReader *myplist = [[YDplistReader alloc] initWithPlistName:plistName];
        NSArray *targets = [myplist arrayOfDictsFromPlist];
        
        [targets enumerateObjectsUsingBlock:^(id  _Nonnull targetName, NSUInteger idx, BOOL * _Nonnull stop) {

            NSString *target = [targetName description];
            
            if ([target isKindOfClass:[NSString class]])
            {
                NSLog(@"🍭Target class: %s", [target UTF8String]);
                __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:[target UTF8String] Original:orig Swizzle:swiz];
            }
        }];
    });
}

- (void)YDHappywebView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler{
    
    NSLog(@"🍭WKWebView bypass applied -> proceed given to challenge from host: %@", [[challenge protectionSpace] host]);
    completionHandler(NSURLSessionAuthChallengeUseCredential, NULL);
}

@end
