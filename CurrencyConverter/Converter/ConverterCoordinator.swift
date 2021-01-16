//
//  Created by Ireneusz Sołek
//  

import UIKit

class ConverterCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  
  func start() -> UIViewController {
    return ConverterViewController()
  }
}
