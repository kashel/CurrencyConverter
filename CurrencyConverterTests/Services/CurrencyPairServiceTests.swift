//
//  Created by Ireneusz Sołek
//  

import XCTest
@testable import CurrencyConverter

class CurrencyPairServiceTests: XCTestCase {
  private var sut: CurrencyPairService!
  private var userDefaultsMock: MockUserDefaults!
  
  override func setUp() {
    userDefaultsMock = MockUserDefaults(suiteName: #file)
    let currencyPair = CurrencyPair(send: Currency(code: "USD", countryCode: "US"), receive: Currency(code: "PLN", countryCode: "PL"))
    userDefaultsMock.mockObjectForKey = try! JSONEncoder().encode([currencyPair])
    sut = CurrencyPairService(userDefaults: userDefaultsMock)
    super.setUp()
  }
  
  func test_insertCall_triggerEncodedDataSave() {
    sut.insert(currencyPair: .mock)
    guard let _ = userDefaultsMock.setValueCalledWithValue as? JSONEncoder.Output else {
      XCTFail("na data has been send for persistency")
      return
    }
  }
  
  func test_deleteCall_triggerEncodedDataSave() {
    sut.delete(currencyPair: .mock)
    guard let _ = userDefaultsMock.setValueCalledWithValue as? JSONEncoder.Output else {
      XCTFail("na data has been send for persistency")
      return
    }
  }
  
  func test_savedCurrencyPairsCall_fetchDataFromPersistentStorage() {
    let expectedPairs = [CurrencyPair.mock]
    let currentPairs = sut.savedCurrencyPairs
    XCTAssertEqual(userDefaultsMock.objectForKeyCalledForKey, "savedCurrencies")
    XCTAssertEqual(currentPairs, expectedPairs)
  }
}
