//
//  Created by Ireneusz Sołek
//  

import UIKit

class DashboardCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  var rootViewController: DashboardViewConroller!
  
  init() {
  }
  
  func start() -> UIViewController {
    let dashboardViewModel = DashboardViewModel(coordinator: self)
    rootViewController = DashboardViewConroller(viewModel: dashboardViewModel)
    return rootViewController
  }
  
  func continueToCurrencySelection() {
    let currencySelectionCoordinator = CurrencySelectionCoordinator()
    currencySelectionCoordinator.lifecycle = { [weak self] coordinatorLifecycleEvent -> Void in
      switch coordinatorLifecycleEvent {
      case .canceled(let childCoordinator):
        self?.remove(childCoordinator: childCoordinator)
        self?.rootViewController.dismiss(animated: true)
      case .finished(let childCoordinator):
        self?.remove(childCoordinator: childCoordinator)
        self?.rootViewController.dismiss(animated: true) {
          guard let self = self else { return }
          self.lifecycle?(.finished(self))
        }
      }
    }
    let currencySelectionViewController = currencySelectionCoordinator.start()
    currencySelectionViewController.modalPresentationStyle = .fullScreen
    rootViewController.present(currencySelectionViewController, animated: true, completion: nil)
    print("pass controll to the next coordinator")
  }
}
