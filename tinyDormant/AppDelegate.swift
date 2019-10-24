import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: health-check for NSURL swizzle
        let _ = NSURL(string: "www.foo.com")
        let _ = NSURL(string: "www.bar.com")
        return true
    }

}

