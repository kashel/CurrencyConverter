//
//  Created by Ireneusz Sołek
//  

import UIKit

final class AppCoordinator : Coordinator {
  typealias Dependencies = ConverterCoordinator.Dependencies
  enum StartScreen {
    case dashboard
    case converter
  }
  
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  var childCoordinators: [Coordinator] = []
  let startScreen: StartScreen
  private let dependencies: Dependencies
  
  private var window : UIWindow?
  private let rootViewController: UIViewController = UIViewController()
  
  init(window : UIWindow?, startScreen: StartScreen, dependencies: Dependencies) {
    self.window = window
    self.startScreen = startScreen
    self.dependencies = dependencies
  }
  
  @discardableResult func start() -> UIViewController {
    
    switch startScreen {
    case .converter:
      startConverter()
    case .dashboard:
      startDashboardCoordinator()
    }
    self.window?.rootViewController = rootViewController
    self.window?.makeKeyAndVisible()
    return rootViewController
  }
  
  private func startConverter() {
    let converterCoordinator = ConverterCoordinator(dependencies: dependencies)
    let converterViewController = converterCoordinator.start()
    add(childCoordinator: converterCoordinator)
    startChildViewController(converterViewController)
  }
  
  private func startDashboardCoordinator() {
    let dashboardCoordinator = DashboardCoordinator(dependencies: dependencies)
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
  
  private func startChildViewController(_ viewController: UIViewController) {
    rootViewController.addChild(viewController)
    rootViewController.view.addSubview(viewController.view)
    viewController.view.pinEdges(to: rootViewController.view)
  }
}
