import UIKit

class YDJediVC: UIViewController {

    let secret_number = 10;
    let secret_string = "foobar";
    let secret_nsstring: NSString = "ewok";
    
    @IBAction func weird_Btn(_ sender: Any) {
        wonderfullyWeird(laugh: secret_number, cry: secret_string)
    }
    
    @objc func wonderfullyWeird(laugh: Int, cry: String){
        print("[*]🎣 a wonderfullyWeird Jedi function")
    }

  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Jedi"
        print("[*]🎣 Jedi VC viewDidLoad")
    }
}

