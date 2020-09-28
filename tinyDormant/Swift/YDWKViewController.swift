import UIKit
import WebKit

class YDWKViewController: UIViewController, WKUIDelegate {

    let boringhNavDel = WKBoringNavDel()
    var webView: WKWebView!
    
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        let dataStore = WKWebsiteDataStore.default()
        configuration.websiteDataStore = dataStore
        if #available(iOS 10.0, *) {
            configuration.dataDetectorTypes = [.all]
        }
        if #available(iOS 11.0, *) {
            configuration.websiteDataStore.httpCookieStore.add(self)
        }
            
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        view = webView
        webView.uiDelegate = self
        webView.navigationDelegate = boringhNavDel
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
        
        let url = URL(string: endpoint)!
        let myRequest = URLRequest(url: url)
        self.webView.load(myRequest)
    }
    
    @objc func refreshWebView(_ sender: UIRefreshControl){
        webView.reloadFromOrigin()
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
//        cookieStore.getAllCookies{ cookies in
//            for cookie in cookies {
//                print("🕵🏼‍♂️ Cookie: \(cookie.name)  | Value: \(cookie.value)")
//            }
//        }
    }
}
