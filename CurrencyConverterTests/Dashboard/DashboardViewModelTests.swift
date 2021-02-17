//
//  Created by Ireneusz Sołek
//  

import XCTest
@testable import CurrencyConverter

class DashboardViewModelTests: XCTestCase {
  var coordinatorMock: DashboardCoordinatorMock!
  var sut: DashboardViewModel!
  
  override func setUp() {
    coordinatorMock = DashboardCoordinatorMock()
    sut = DashboardViewModel(coordinator: coordinatorMock)
    super.setUp()
  }
  
  func test_continueAction_triggersCoordinatorAction() {
    sut.continueAction()
    XCTAssertTrue(coordinatorMock.continueToCurrencySelectionCalled)
  }
}
