//
//  Created by Ireneusz Sołek
//  

import UIKit

enum CoordinatorLifecycleEvent {
  case finished(Coordinator)
  case canceled(Coordinator)
  
  var coordinator: Coordinator {
    switch self {
    case .finished(let coordinator),
         .canceled(let coordinator):
      return coordinator
    }
  }
}

protocol Coordinator: AnyObject {
  var childCoordinators: [Coordinator] { get set }
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)? { get set }
  func start() -> UIViewController
}

extension Coordinator {
  func add(childCoordinator coordinator: Coordinator) {
    coordinator.lifecycle = { (event: CoordinatorLifecycleEvent) -> Void in
      coordinator.remove(childCoordinator: event.coordinator)
    }
    childCoordinators.append(coordinator)
  }
  
  func remove(childCoordinator coordinator: Coordinator) {
    childCoordinators = childCoordinators.filter { $0 !== coordinator }
  }
}
