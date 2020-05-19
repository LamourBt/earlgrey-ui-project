import UIKit

struct LaunchArguments {
    static let UI_TEST = "testMode"
}

struct AppEnvironment {
    public static var isRunningTest: Bool {
        return ProcessInfo().arguments.contains(LaunchArguments.UI_TEST)
    }
}

//@UIApplicationMain can't have this since we've created a main.swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let loginController = LogInViewController(service: makeService())
        window?.rootViewController = loginController
        window?.makeKeyAndVisible()
        return true
    }
    
    func makeService() -> ApiServiceProtocol {
        return ApiService()
    }
}

extension UIViewController {
    var appDelegate: AppDelegate {
        guard let _app = UIApplication.shared.delegate as? AppDelegate
            else { fatalError("Couldn't cast to AppDelegate") }
        return _app
    }
}
