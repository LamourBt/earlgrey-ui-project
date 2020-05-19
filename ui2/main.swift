import Foundation
import UIKit

private var appDelegate: AppDelegate.Type

if AppEnvironment.isRunningTest {
    appDelegate = FakeAppDelegate.self
} else {
    appDelegate = AppDelegate.self
}


_ = UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(UIApplication.self), NSStringFromClass(appDelegate))
