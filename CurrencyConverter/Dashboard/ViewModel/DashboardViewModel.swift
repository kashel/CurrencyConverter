//
//  Created by Ireneusz Sołek
//  

import Foundation

struct DashboardViewModel {
  let coordinator: DashboardCoordinator
  
  var ctaButtonTitle: String {
    return "Add currency pair"
  }
  
  func continueAction() {
    coordinator.continueToCurrencySelection()
  }
}
