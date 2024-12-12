import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initializeWindow()
        return true
    }
    
    func initializeWindow() {
        var rootController: UIViewController
        window = UIWindow(frame: UIScreen.main.bounds)
        
        rootController = TasksScreenViewController()
        window?.rootViewController = rootController
        window?.backgroundColor = .red
        window?.makeKeyAndVisible()
//        configureNavigationBar()
    }
}
