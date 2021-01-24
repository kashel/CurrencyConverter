//
//  Created by Ireneusz Sołek
//  

import Foundation
@testable import CurrencyConverter

class DashboardCoordinatorMock: DashboardCoordinatorProtocol {
  var continueToCurrencySelectionCalled: Bool = false
  func continueToCurrencySelection() {
    continueToCurrencySelectionCalled = true
  }
}
