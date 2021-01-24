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
    let currencyPairService = CurrencyPairService()
    let startScreen: AppCoordinator.StartScreen = currencyPairService.savedCurrencyPairs.count > 0 ? .converter : .dashboard
    applicationCoordinator = AppCoordinator(window: window, startScreen: startScreen)
    applicationCoordinator.start()
    return true
  }
}

