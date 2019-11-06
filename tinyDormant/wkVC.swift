import UIKit
import WebKit

class YDWKViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
        
    override func loadView() {
        let configuration = WKWebViewConfiguration()

        if #available(iOS 10.0, *) {
            configuration.dataDetectorTypes = [.all]
        }
        if #available(iOS 11.0, *) {
            configuration.websiteDataStore.httpCookieStore.add(self)
        }
            
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.customUserAgent = "YDWKDemoUserAgent"
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        view = webView
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
    }

    //MARK: WKnavigationDelegate
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
                // handle Unauthorized request
            }
        }

        //print("🕵🏼‍♂️ WKNavigationResponse \(navigationResponse.response as? HTTPURLResponse)") // WKNavigationResponse always nil
        
        decisionHandler(.allow)
        return
    }
    
    //MARK: WKUIDelegate
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("🕵🏼‍♂️ runJavaScriptAlertPanelWithMessage called")
        let alertController = UIAlertController(title: message, message: nil,
                                                preferredStyle: UIAlertController.Style.alert);
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
            _ in completionHandler()}
        );
        
        self.present(alertController, animated: true, completion: {});
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
        webView.scrollView.addSubview(refreshControl)
        webView.scrollView.bounces = true
        if let myURL = URL(string: "https://httpbin.org/cookies/set?HAPPY=DayOfTheJackel") {
            let myRequest = URLRequest(url: myURL)
            self.webView.load(myRequest)
        }
    }
    
    @objc func refreshWebView(_ sender: UIRefreshControl){
        webView.reload()
        sender.endRefreshing()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print("🕵🏼‍♂️ progress -> "  + String(webView.estimatedProgress))
        }
        if keyPath == "title" {
            if let title = webView.title {
                print("🕵🏼‍♂️ title -> " + title)
            }
        }
    }
}

extension YDWKViewController: WKHTTPCookieStoreObserver {
    @available(iOS 11.0, *)
    func cookiesDidChange(in cookieStore: WKHTTPCookieStore) {
        cookieStore.getAllCookies{ cookies in
            for cookie in cookies {
                print("🕵🏼‍♂️ Cookie: \(cookie.name)  | Value: \(cookie.value)")
            }
        }
    }
}
