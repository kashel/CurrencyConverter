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
    applicationCoordinator = AppCoordinator(window: window, currentCurrencyPairs: [])
    applicationCoordinator.start()
    return true
  }
}

