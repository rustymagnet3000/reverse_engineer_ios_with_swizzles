#import "YDNavDel.h"

@implementation YDNavDel

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
        NSLog(@"🍭didStartProvisionalNavigation");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"🍭decidePolicyForNavigationAction URL：%@", navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
    NSLog(@"🍭challenge from: %@", [[challenge protectionSpace] host]);
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, NULL);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"🍭didFinishNavigation");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"🍭didFailNavigation");
}

@end
