#include "swizzleHelper.h"
#include "YDNavDel.h"
#import <WebKit/WebKit.h>

/*  @selector(navigationDelegate) is not called
SEL swiz= @selector(YDnavigationDelegate);         */

@interface Foobar : NSObject
@property (class) YDNavDel *hotDel;
@end

@implementation Foobar
static YDNavDel *_hotDel;
+ (YDNavDel *)hotDel { return _hotDel; }
+ (void)setHotDel:(YDNavDel *)newHotDel { _hotDel = newHotDel; }
@end

@implementation NSObject (YDswizzleSetNavDelegate)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL orig = @selector(setNavigationDelegate:);
        SEL swiz= @selector(YDsetNavigationDelegate:);
        
        YDNavDel *customDel = [[YDNavDel alloc] init];
        [Foobar setHotDel:customDel];
        NSLog(@"🍭Foobar alive: %@", [Foobar hotDel]);
        __unused SwizzleHelper *swizzle = [[SwizzleHelper alloc] initWithTargets:WKWebViewClassStr Original:orig Swizzle:swiz];
    });
}

- (void)YDsetNavigationDelegate:(id)originalDelegate {
    [self YDsetNavigationDelegate:NULL];
}

@end
