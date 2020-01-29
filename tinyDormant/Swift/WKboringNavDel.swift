import Foundation
import WebKit

class WKBoringNavDel: NSObject, WKNavigationDelegate, WKHTTPCookieStoreObserver {

    @available(iOS 11.0, *)
    func cookiesDidChange(in cookieStore: WKHTTPCookieStore) {
        print("🕵🏼‍♂️ A Cookie changed!")
        cookieStore.getAllCookies{ cookies in
            for cookie in cookies {
                print("\(cookie.name) is set to \(cookie.value)")
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        NSLog("🕵🏼‍♂️ Boring decidePolicyFor: \(String(describing: webView.url))")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        //  NSLog("🕵🏼‍♂️ Boring challanged by: \(challenge.protectionSpace.host)")

        guard let trust: SecTrust = challenge.protectionSpace.serverTrust else {
            return
        }
        
        var secResult = SecTrustResultType.deny
        let _ = SecTrustEvaluate(trust, &secResult)
        
        switch secResult {
            case .proceed:
                NSLog("🕵🏼‍♂️ SecTrustEvaluate ✅")
                completionHandler(.performDefaultHandling, nil)
            
            case .unspecified:
               // NSLog("🕵🏼‍♂️  ✅ Apple recommend “Use System Policy” is a pass")
                completionHandler(.performDefaultHandling, nil)
            
            default:
                NSLog("🕵🏼‍♂️❌ SecTrustEvaluate default error \(secResult.rawValue)")
                completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        ydHandleError(error: error)

    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ydHandleError(error: error)
    }
    
    func ydHandleError(error: Error) {
        print("🕵🏼‍♂️ ydHandleError: \(error.localizedDescription)")

    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        if let response = navigationResponse.response as? HTTPURLResponse {
            if response.statusCode == 401 {
                print("🕵🏼‍♂️ 401 unauthorized")
            }
        }

        decisionHandler(.allow)
        return
    }
}
