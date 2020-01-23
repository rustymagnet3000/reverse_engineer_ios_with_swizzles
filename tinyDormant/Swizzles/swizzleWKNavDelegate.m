#include "swizzleHelper.h"
#include "YDNavDel.h"
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
        
        __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:WKWebViewClassStr Original:orig Swizzle:swiz];
    });
}

- (void)YDsetNavigationDelegate:(id)vcWithWK {
    
    if ([self isKindOfClass:[WKWebView class]] && [vcWithWK isKindOfClass:[UIViewController class]]) {
        NSLog(@"🍭setNavigationDelegate\n\t🍭self is: %@\n\t🍭ptr class of: %@", self, [vcWithWK self]);
    }
    else {
        NSLog(@"🍭SetNavDel unexpected class: %@", [vcWithWK self]);
        NSLog(@"🍭SetNavDel unexpected self: %@", self)
    }

    YDNavDel *customDel = [[YDNavDel alloc] init];
    NSLog(@"🍭customDel ptr: %@", customDel);
    [self YDsetNavigationDelegate:customDel];

}

@end
