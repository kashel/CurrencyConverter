//
//  Created by Ireneusz Sołek
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var applicationCoordinator: AppCoordinator!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let currencyPairService = CurrencyPairService(currencyService: CurrencyService())
    let startScreen: AppCoordinator.StartScreen = currencyPairService.savedCurrencyPairs.count > 0 ? .converter : .dashboard
    applicationCoordinator = AppCoordinator(window: window, startScreen: startScreen)
    applicationCoordinator.start()
    return true
  }
}

