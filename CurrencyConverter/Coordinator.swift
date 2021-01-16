//
//  Created by Ireneusz Sołek
//  

import UIKit

enum CoordinatorLifecycleEvent {
  case finished(Coordinator)
  case canceled(Coordinator)
}

protocol Coordinator: AnyObject {
  var childCoordinators: [Coordinator] { get set }
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)? { get set }
  func start() -> UIViewController
}

extension Coordinator {
  func add(childCoordinator coordinator: Coordinator) {
    coordinator.lifecycle = { (event: CoordinatorLifecycleEvent) -> Void in
      switch event {
        case .finished(let childCoordinator), .canceled(let childCoordinator):
          coordinator.remove(childCoordinator: childCoordinator)
      }
    }
    childCoordinators.append(coordinator)
  }
  
  func remove(childCoordinator coordinator: Coordinator) {
    self.childCoordinators = self.childCoordinators.filter({ $0 !== coordinator })
  }
}
