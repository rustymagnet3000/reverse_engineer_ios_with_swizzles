import UIKit

class YDMandalorianVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let view = UIView(frame: rect)
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        view.center = CGPoint(x: UIScreen.main.bounds.size.width*0.5, y: UIScreen.main.bounds.size.height*0.5)
        gradient.colors = [UIColor.blue.cgColor, UIColor.green.cgColor]
        view.layer.insertSublayer(gradient, at: 1)
        self.view.addSubview(view)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.text = "Mandalorian"
        view.addSubview(label)
    }

}
