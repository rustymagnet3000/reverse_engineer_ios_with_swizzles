#include "swizzleHelper.h"
#import <WebKit/WebKit.h>

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...) {}
#endif

@interface YDSwizzledNavDel : NSObject  <WKNavigationDelegate>
@property (nonatomic) WKWebView *webView;
@end

@implementation YDSwizzledNavDel

#pragma mark - Private Methods

- (void)setupFakeWebView {
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKWebsiteDataStore *dataStore = [WKWebsiteDataStore defaultDataStore];
    config.websiteDataStore = dataStore;
    
    self.webView = [[WKWebView alloc] initWithFrame: CGRectZero
                                      configuration: config];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
    NSLog(@"🍭challenge from: %@", [[challenge protectionSpace] host]);
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, NULL);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"🍭decidePolicyForNavigationAction URL：%@", navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"🍭didStartProvisionalNavigation");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"🍭didFinishNavigation");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"🍭didFailNavigation");
}

@end


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
        NSLog(@"🍭SetNavDel unexpected class: %@", [vcWithWK class]);
        NSLog(@"🍭SetNavDel unexpected self: %@", self)
    }
    
    YDSwizzledNavDel *fake_wk_nav_del = [[YDSwizzledNavDel alloc] init];
    [fake_wk_nav_del setupFakeWebView];
    NSLog(@"🍭fake_wk_vc class: %@", [fake_wk_nav_del self]);
    [self YDsetNavigationDelegate:NULL];
    NSLog(@"🍭Ptr to Nav Delegate: %@", [[fake_wk_nav_del webView] navigationDelegate]);
    
}

@end
