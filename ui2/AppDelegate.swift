import UIKit


extension UIViewController {
    var appDelegate: AppDelegate {
        guard let _app = UIApplication.shared.delegate as? AppDelegate
            else { fatalError("Couldn't cast to AppDelegate") }
        return _app
    }
}

extension UIApplication {
    // set via scheme arguments
    public static var isRunningTest: Bool {
        return ProcessInfo().arguments.contains("testMode")
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let service: ServiceProtocol = UIApplication.isRunningTest ? MockedService() : Service()
        let loginController = LogInViewController(service: service)
        window?.rootViewController = loginController
        window?.makeKeyAndVisible()
        return true
    }
}

