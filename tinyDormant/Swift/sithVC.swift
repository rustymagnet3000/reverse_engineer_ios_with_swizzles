import UIKit

class YDSithVC: UIViewController {
    
    private let scary_voice = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sith VC"
        print("[+]🧪 the Sith VC ViewDidLoad!")
    }
    
    override func loadView() {
        // super.loadView()   // NOT call super
        // https://developer.apple.com/documentation/uikit/uiviewcontroller/1621454-loadview
        let strings: [String] = ["Sidious","Bane","Vader","Maul","Dooku"]
        let stackView = UIStackView()
        let button = UIButton(type: .system)
        view = UIView()
        view.backgroundColor = .yellow
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30.0
        stackView.distribution  = .equalSpacing
        stackView.alignment = .center
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        button.setTitle("✸ Secret ✸", for: .normal)
        button.YDButtonStyle(ydColor: UIColor.black)

        button.addTarget(self, action: #selector(self.lightsaber), for: .touchUpInside)
        view.addSubview(button)
        
        for string in strings {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = string
            stackView.addArrangedSubview(label)
        }
        stackView.addArrangedSubview(button)
    }
    
    @objc func lightsaber() {
        let secret_of_sith = "[+]🧪 Sith use Red lightsabers!"
        let ydAlertController = UIAlertController(title: "**  Sith  **", message: secret_of_sith, preferredStyle: .alert)
        let ydAction = UIAlertAction(title: "Blow up planet", style: .destructive) { (action:UIAlertAction) in
            
            let porgvc = YDPorgVC(nibName: "PorgViewController", bundle: nil)
            self.navigationController?.pushViewController(porgvc, animated: true)
            
        }
        ydAlertController.addAction(ydAction)
        self.present(ydAlertController, animated: true, completion: nil)
    }
}


extension UIButton {
    func YDButtonStyle(ydColor:UIColor) {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 5
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.black, for: .selected)
        self.backgroundColor = ydColor
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 120)
            ])
    }
}
