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
    let dashboardViewModel = DashboardViewModel(coordinator: self)
    let dashboardViewConroller = DashboardViewConroller(viewModel: dashboardViewModel)
    rootViewController = UINavigationController(rootViewController: dashboardViewConroller)
    return rootViewController
  }
  
  func continueToCurrencySelection() {
    print("pass controll to the next coordinator")
  }
}
