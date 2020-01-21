#include "swizzleHelper.h"
#import <WebKit/WebKit.h>

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...) {}
#endif

@implementation NSObject (YDswizzleSetNavDelegate)
 
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL orig = @selector(setNavigationDelegate:);
        SEL swiz= @selector(YDsetNavigationDelegate:);
        
        __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:"WKWebView" Original:orig Swizzle:swiz];
    });
}

- (void)YDsetNavigationDelegate:(id)vcWithWK {
    
    if ([self isKindOfClass:[WKWebView class]] && [vcWithWK isKindOfClass:[UIViewController class]]) {
        NSLog(@"🍭setNavigationDelegate\n\tself is: %@\n\tptr class of: %@", NSStringFromClass([WKWebView class]), [vcWithWK class]);
    }
    else {
        NSLog(@"🍭Unexpected classes inside of setNavigationDelegate:");
        return;
    }
    
    #pragma mark - turns OFF Nav Delegate code
    [self YDsetNavigationDelegate:NULL];
}

@end
