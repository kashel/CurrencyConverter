//
//  Created by Ireneusz Sołek
//  

import XCTest
@testable import CurrencyConverter

class CurrencyServiceTests: XCTestCase {
  
  private var sut: CurrencyService!
  
  override func setUp() {
    sut = CurrencyService()
    super.setUp()
  }
  
  func test_supportedCurrencyCodes_are3CharactersLength() {
    if let _ = sut.availableCurrencies.map{ $0.code.count }.filter({ $0 != 3 }).first {
      XCTFail("only 3 characters long currency codes are supported, check supportedCurrencyCodes array")
    }
  }
  
  func test_findAvailableCurrency_suceedWhenFidingSupportedCurrencyCode() {
    let currency = sut.findAvailableCurrency(by: "GBP")
    if currency == .none {
      XCTFail("FindAvailableCurrency should succedd for supported currency code")
    }
  }
  
  func test_findAvailableCurrency_failWhenFidingUnsupportedCurrencyCode() {
    let currency = sut.findAvailableCurrency(by: "XXX")
    if currency != nil {
      XCTFail("FindAvailableCurrency should fail for unsupported currency code")
    }
  }
}
