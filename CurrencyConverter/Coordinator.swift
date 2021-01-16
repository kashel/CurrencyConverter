//
//  Created by Ireneusz Sołek
//  

import UIKit

enum CoordinatorLifecycleEvent {
  case finished(Coordinator)
  case failed(Coordinator)
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
        case .finished(let coordinator), .failed(let coordinator):
          self.childCoordinators = self.childCoordinators.filter({ $0 !== coordinator })
      }
    }
    childCoordinators.append(coordinator)
  }
}
