import UIKit

class YDURLSessionVC: UIViewController, URLSessionDataDelegate {
    
    fileprivate let noOfRequests = 5
    fileprivate let target = "https://www.google.com"
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration,
                          delegate: self, delegateQueue: nil)
    }()
    var receivedData: Data?
    var results: YDResultModel = YDResultModel()
    @IBOutlet weak var request_lbl: UILabel!
    @IBOutlet weak var url_lbl: UILabel!
    @IBOutlet weak var time_lbl: UILabel!
    @IBOutlet weak var success_lbl: UILabel!
    @IBOutlet weak var failed_lbl: UILabel!
    
    @IBOutlet var labels: [UILabel] = []
    
    @IBOutlet weak var progress_bar: UIProgressView!{
        didSet {
            self.progress_bar.setProgress(0.0, animated: true)
        }
    }

    var counter:Int = 0 {
        didSet {
            request_lbl.isHidden = false
            let fractionalProgress = Float(counter) / Float(noOfRequests)
            let animated = counter != 0
            progress_bar.setProgress(fractionalProgress, animated: animated)
            request_lbl.text = ("request \(counter)")
        }
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        results = YDResultModel()
        counter = 0
        receivedData = Data()
        sendRequestUpdateUI()
    }
    
    func sendRequestUpdateUI() {
        guard counter < noOfRequests else {
            self.time_lbl.text = String(self.results.totalTimeTaken) + " seconds"
            return
        }

        counter += 1
        let request = URLRequest(url: URL(string: target)!)
        let task = session.dataTask(with: request)
        task.resume()
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.sendRequestUpdateUI()
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request_lbl.isHidden = true
        url_lbl.text = target
    }
    

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }
        print("response: \(httpResponse.statusCode)")
        switch httpResponse.statusCode {
            case 200 ... 399:
                self.results.successCounter += 1

            default:
                self.results.failCounter += 1
            }

        completionHandler(.allow)
    }

   
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
     
        
        print("🕵🏼‍♂️ challanged by: \(challenge.protectionSpace.host)")

        guard let trust: SecTrust = challenge.protectionSpace.serverTrust else {
            return
        }
        
        var secResult = SecTrustResultType.deny
        let _ = SecTrustEvaluate(trust, &secResult)
        
        switch secResult {
            case .proceed:
                print("🕵🏼‍♂️ SecTrustEvaluate ✅")
                completionHandler(.performDefaultHandling, nil)
            case .unspecified:
                print("🕵🏼‍♂️ SecTrustResultType = unspecified. Letting pass ✅")
                completionHandler(.performDefaultHandling, nil)
            default:
                print("🕵🏼‍♂️ SecTrustEvaluate ❌ default error \(secResult.rawValue)")
                completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}

