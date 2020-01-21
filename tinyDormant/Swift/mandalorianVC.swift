import UIKit

class YDMandalorianVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mandalorian"
        print("[+] Invoked the MandalorianVC VC ViewDidLoad!")
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func secret_mandalorian() {
        print("[+]Invoked the Mandalorian secret!")
    }
}
