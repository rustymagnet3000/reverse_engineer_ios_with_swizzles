#include "swizzleHelper.h"
#import <WebKit/WebKit.h>

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...) {}
#endif

/* Signature
 -[WKWebView setNavigationDelegate:]
 
 (lldb) b -[WKWebView setNavigationDelegate:]

 // breakpoint fires

 (lldb) po $arg1
 <WKWebView: 0x7f8e90875400; frame = (0 0; 0 0); layer = <CALayer: 0x600000fdfb20>>

 (lldb) p (char *) $arg2
 (char *) $13 = 0x00007fff51f655b3 "setNavigationDelegate:"

 (lldb) po $arg3
 <tinyDormant.YDWKViewController: 0x7f8e8f416350>
*/

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
        NSLog(@"🍭setNavigationDelegate\tself is: %@", NSStringFromClass([WKWebView class]));
        NSLog(@"🍭setNavigationDelegate ptr class of: %@", [vcWithWK class]);
    }
    else {
        NSLog(@"🍭Unexpected classes inside of setNavigationDelegate:");
        return;
    }
    (void)[self YDsetNavigationDelegate:vcWithWK];

//    (void)[self YDsetNavigationDelegate:NEWNAVDEL];
}


@end
