//
//  Created by Ireneusz Sołek
//  

import Foundation
@testable import CurrencyConverter


class CurrencySelectionCoordinatorMock: CurrencySelectionCoordinatorProtocol {
  
  var selectReceiveCurrencyCalledWithPreviouslySelected: Currency?
  func selectReceiveCurrency(previouslySelected: Currency) {
    selectReceiveCurrencyCalledWithPreviouslySelected = previouslySelected
  }
  
  var currencyPairSelectedCalledWithCurrencyPair: CurrencyPair?
  func currencyPairSelected(_ currencyPair: CurrencyPair) {
    currencyPairSelectedCalledWithCurrencyPair = currencyPair
  }
  
  var selectionCanceledCalled: Bool = false
  func selectionCanceled() {
    selectionCanceledCalled = true
  }
}
