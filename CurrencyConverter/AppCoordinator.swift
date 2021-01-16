//
//  Created by Ireneusz Sołek
//  

import UIKit

final class AppCoordinator : Coordinator {
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  var childCoordinators: [Coordinator] = []
    private var window : UIWindow?
    
    init(window : UIWindow?) {
        self.window = window
    }
    
    @discardableResult func start() -> UIViewController {
      let dashboardCoordinator = DashboardCoordinator()
      add(childCoordinator: dashboardCoordinator)
      let dashboardViewController = dashboardCoordinator.start()
      self.window?.rootViewController = dashboardViewController
      self.window?.makeKeyAndVisible()
      return dashboardViewController
    }
}
