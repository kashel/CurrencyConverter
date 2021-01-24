//
//  Created by Ireneusz Sołek
//  

import Foundation

struct DashboardViewModel {
  weak var coordinator: DashboardCoordinatorProtocol?
  
  var ctaButtonTitle: String {
    return L10n.addCurrencyPair
  }
  
  func continueAction() {
    coordinator?.continueToCurrencySelection()
  }
}
