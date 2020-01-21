import UIKit

class YDJediVC: UIViewController {

    let secret_number = 10;
    let secret_string = "foobar";
    let secret_nsstring: NSString = "ewok";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Jedi"
        print("[+] 🎣 Jedi VC viewDidLoad")
    }
}

