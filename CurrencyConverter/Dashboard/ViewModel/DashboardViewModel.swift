//
//  Created by Ireneusz Sołek
//  

import Foundation

struct DashboardViewModel {
  weak var coordinator: DashboardCoordinator?
  
  var ctaButtonTitle: String {
    return "Add currency pair"
  }
  
  func continueAction() {
    coordinator?.continueToCurrencySelection()
  }
}
