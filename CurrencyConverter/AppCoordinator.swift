//
//  Created by Ireneusz Sołek
//  

import UIKit

final class AppCoordinator : Coordinator {
  enum StartScreen {
    case dashboard
    case converter
  }
  
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  var childCoordinators: [Coordinator] = []
  var startScreen: StartScreen {
    return childCoordinators.count > 0 ? .converter : .dashboard
  }
  
  private var window : UIWindow?
  private let currentCurrencyPairs: [CurrencyPair]
  private let rootViewController: UIViewController = UIViewController()
  
  init(window : UIWindow?, currentCurrencyPairs: [CurrencyPair]) {
    self.window = window
    self.currentCurrencyPairs = currentCurrencyPairs
  }
  
  @discardableResult func start() -> UIViewController {
    
    switch startScreen {
    case .converter:
      startConverter()
    case .dashboard:
      let dashboardCoordinator = DashboardCoordinator()
      add(childCoordinator: dashboardCoordinator)
      let dashboardViewController = dashboardCoordinator.start()
      dashboardCoordinator.lifecycle = {[weak self, weak dashboardCoordinator] childCoordinatorEvent in
        switch childCoordinatorEvent {
        case .canceled:
          assertionFailure("Dashboard coordinator can not be canceled")
        case .finished(let childCoordinator) where childCoordinator is DashboardCoordinator:
          dashboardViewController.view.removeFromSuperview()
          dashboardViewController.removeFromParent()
          if let unownedDashboardCoordinator = dashboardCoordinator {
            self?.remove(childCoordinator: unownedDashboardCoordinator)            
          }
          self?.startConverter()
        case .finished:
          assertionFailure("childCoordinator has to be DashboardCoordinator")
        }
      }
      startChildViewController(dashboardViewController)
    }
    self.window?.rootViewController = rootViewController
    self.window?.makeKeyAndVisible()
    return rootViewController
  }
  
  private func startConverter() {
    let converterCoordinator = ConverterCoordinator()
    let converterViewController = converterCoordinator.start()
    add(childCoordinator: converterCoordinator)
    startChildViewController(converterViewController)
  }
  private func startChildViewController(_ viewController: UIViewController) {
    rootViewController.addChild(viewController)
    rootViewController.view.addSubview(viewController.view)
    viewController.view.pinEdges(to: rootViewController.view)
  }
}
