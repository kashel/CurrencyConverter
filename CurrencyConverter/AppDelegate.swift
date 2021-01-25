//
//  Created by Ireneusz Sołek
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var applicationCoordinator: AppCoordinator!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    let isUITest = ProcessInfo.processInfo.isUITestRun
    let dependencyContainer: AppCoordinator.Dependencies = isUITest ? MockDependencyContainer() : DependencyContainer()
    let startScreen: AppCoordinator.StartScreen = dependencyContainer.currencyPairService.savedCurrencyPairs.count > 0 ? .converter : .dashboard
    applicationCoordinator = AppCoordinator(window: window, startScreen: startScreen, dependencies: dependencyContainer)
    applicationCoordinator.start()
    return true
  }
}

