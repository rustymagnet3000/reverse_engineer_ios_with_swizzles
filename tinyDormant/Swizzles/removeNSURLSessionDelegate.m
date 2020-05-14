#include "swizzleHelper.h"

@implementation NSObject (YDRemoveNSURLSession)
 
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL orig = @selector(sessionWithConfiguration:delegate:delegateQueue:);
        SEL swiz = @selector(YDsessionWithConfiguration:delegate:delegateQueue:);
        __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:"NSURLSession" Original:orig Swizzle:swiz];
    });
}

+ (NSURLSession *)YDsessionWithConfiguration:(NSURLSessionConfiguration *)configuration delegate:(id<NSURLSessionDelegate>)delegate delegateQueue:(NSOperationQueue *)queue{

    NSLog(@"🍭Inside NSURLSession setup.Dropping delegate %@", delegate);
    NSURLSession *sessionWithNoDelegate = [NSURLSession YDsessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSLog(@"🍭Returned NSURLSession  %@", sessionWithNoDelegate);
    return sessionWithNoDelegate;
}

@end
