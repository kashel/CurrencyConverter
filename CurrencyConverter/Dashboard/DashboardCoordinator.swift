//
//  Created by Ireneusz Sołek
//  

import UIKit

class DashboardCoordinator: Coordinator {
  weak var rootViewController: UINavigationController!
  
  var childCoordinators: [Coordinator] = []
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  
  init() {
  }
  
  func start() -> UIViewController {
    let dashboardViewConroller = DashboardViewConroller()
    rootViewController = UINavigationController(rootViewController: dashboardViewConroller)
    return rootViewController
  }
}
