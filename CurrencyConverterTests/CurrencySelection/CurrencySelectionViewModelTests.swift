//
//  Created by Ireneusz Sołek
//  

import XCTest
@testable import CurrencyConverter

class CurrencySelectionViewModelTests: XCTestCase {
  var modelMapper: CurrencySelectionCellModelMapperMock!
  var coordinatorMock: CurrencySelectionCoordinatorMock!
  var mockDepenencyContainer: MockDependencyContainer!
  var sut: CurrencySelectionViewModel!
  
  override func setUp() {
    modelMapper = CurrencySelectionCellModelMapperMock()
    coordinatorMock = CurrencySelectionCoordinatorMock()
    mockDepenencyContainer = MockDependencyContainer(launchScreen: .converter)
    super.setUp()
  }
  
  func test_continueActionForReceiveCurrencySelectionContinuation_callsProperCoordinatorMethod() {
    var selectedSendCurrency: Currency?
    sut = CurrencySelectionViewModel(ctaAction: .goToReceiveCurrencySelection,
                                     currencySelectionCellModelMapper: modelMapper,
                                     coordinator: coordinatorMock,
                                     dependencies: mockDepenencyContainer)
    
    sut.continueAction(selectedCurrency: .usDolar)
    if let previouslySelectedCurrency = coordinatorMock.selectReceiveCurrencyCalledWithPreviouslySelected {
      selectedSendCurrency = previouslySelectedCurrency
    }
    
    XCTAssertEqual(selectedSendCurrency, .usDolar)
  }
  
  func test_continueActionForCurrencySelectionDoneContinuation_callsProperCoordinatorMethod() {
    var selectedCurrencyPair: CurrencyPair?
    sut = CurrencySelectionViewModel(ctaAction: .currencyPairSelected(sendCurrency: .usDolar),
                                     currencySelectionCellModelMapper: modelMapper,
                                     coordinator: coordinatorMock,
                                     dependencies: mockDepenencyContainer)
    
    sut.continueAction(selectedCurrency: .polishZloty)
    if let completedWithCurrencyPair = coordinatorMock.currencyPairSelectedCalledWithCurrencyPair {
      selectedCurrencyPair = completedWithCurrencyPair
    }
    
    XCTAssertEqual(selectedCurrencyPair?.send, .usDolar)
    XCTAssertEqual(selectedCurrencyPair?.receive, .polishZloty)
  }
  
  func test_receivingCancelationEvent_triggerProperCoordinatorMethod() {
    sut = CurrencySelectionViewModel(ctaAction: .goToReceiveCurrencySelection,
                                     currencySelectionCellModelMapper: modelMapper,
                                     coordinator: coordinatorMock,
                                     dependencies: mockDepenencyContainer)
    sut.cancelAction()
    XCTAssertTrue(coordinatorMock.selectionCanceledCalled)
  }
}
