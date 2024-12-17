import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializeWindow()
        return true
    }
    
    private func initializeWindow() {
        var rootController: UIViewController
        window = UIWindow(frame: UIScreen.main.bounds)
        
        rootController = TasksScreenAssembly.assemble()
        let navBar = UINavigationController(rootViewController: rootController)
        window?.rootViewController = navBar
        window?.makeKeyAndVisible()
    }
}
