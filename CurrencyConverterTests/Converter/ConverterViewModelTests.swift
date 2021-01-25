//
//  Created by Ireneusz Sołek
//  

import XCTest
@testable import CurrencyConverter

class ConverterViewModelTests: XCTestCase {
  var currencyPairServiceMock: CurrencyPairServiceMock!
  var exchangeRateServiceMock: ExchangeRatesServiceMock!
  var exchangeRates = [ExchangeRateModel(sourceCurrency: .usDolar, sourceAmount: 1, receiveCurrency: .polishZloty, receiveAmount: 4)]
  var currencyPairs = [CurrencyPair(send: .usDolar, receive: .polishZloty)]
  var sut: ConverterViewModel!
  
  override func setUp() {
    currencyPairServiceMock = CurrencyPairServiceMock()
    exchangeRateServiceMock = ExchangeRatesServiceMock()
    exchangeRateServiceMock.exchangeRateResult = .success(exchangeRates)
    currencyPairServiceMock.currencyPairs = currencyPairs
    sut = ConverterViewModel(currencyPairService: currencyPairServiceMock, exchangeRateService: exchangeRateServiceMock)
    super.setUp()
  }
  
  func test_startLoading_triggerInitialDataLoadedEvent() {
    var loadedRates: [ExchangeRateModel]?
    let expectation = XCTestExpectation(description: "initialDataLoaded action called")
    
    sut.actions = { action in
      switch action {
      case .initialDataLoaded(let rates):
        loadedRates = rates
        expectation.fulfill()
      default:
        print("continue")
      }
    }
    
    sut.startLoading()
    wait(for: [expectation], timeout: 2)
    XCTAssertEqual(exchangeRates.first!.sourceCurrency, loadedRates?.first!.sourceCurrency)
    XCTAssertEqual(exchangeRates.first!.receiveCurrency, loadedRates?.first!.receiveCurrency)
    XCTAssertEqual(exchangeRates.first!.sourceAmount, loadedRates?.first!.sourceAmount)
    XCTAssertEqual(exchangeRates.first!.receiveAmount, loadedRates?.first!.receiveAmount)
  }
  
  func test_startLoading_triggerAdditionalDataLoadedEvent() {
    var isNewRateAdded: Bool = false
    let expectation = XCTestExpectation(description: "initialDataLoaded action called")
    var fetchedAdditionalRates: [ExchangeRateModel]?
    
    var startLoadingCompleted: (() -> Void)? = {
      DispatchQueue.main.async {
        self.exchangeRates.append(ExchangeRateModel.init(sourceCurrency: .polishZloty, sourceAmount: 1, receiveCurrency: .usDolar, receiveAmount: 0.01))
        self.exchangeRateServiceMock.exchangeRateResult = .success(self.exchangeRates)
        self.sut.currencyPairAdded(CurrencyPair(send: .polishZloty, receive: .usDolar))
      }
    }
    
    sut.actions = { action in
      print(action)
      switch action {
      case .dataLoaded(let allRates, let newRateAdded):
        if let loadingCompleted = startLoadingCompleted {
          loadingCompleted()
          startLoadingCompleted = nil
          return
        }
        fetchedAdditionalRates = allRates
        isNewRateAdded = newRateAdded
        expectation.fulfill()
      default:
        print("continue")
      }
    }
    
    sut.startLoading()
    
    wait(for: [expectation], timeout: 5)
    XCTAssertTrue(isNewRateAdded)
    XCTAssertEqual(exchangeRates[1].sourceCurrency, fetchedAdditionalRates?[1].sourceCurrency)
    XCTAssertEqual(exchangeRates[1].receiveCurrency, fetchedAdditionalRates?[1].receiveCurrency)
    XCTAssertEqual(exchangeRates[1].sourceAmount, fetchedAdditionalRates?[1].sourceAmount)
    XCTAssertEqual(exchangeRates[1].receiveAmount, fetchedAdditionalRates?[1].receiveAmount)
  }
  
  func test_receivingCurrencyPairAddedEvent_pausesDataFetch() {
    test_cancellingEvent_pausesDataFetch {
      self.exchangeRates.append(ExchangeRateModel.init(sourceCurrency: .polishZloty, sourceAmount: 1, receiveCurrency: .usDolar, receiveAmount: 0.01))
      self.exchangeRateServiceMock.exchangeRateResult = .success(self.exchangeRates)
      self.sut.currencyPairAdded(CurrencyPair(send: .polishZloty, receive: .usDolar))
    }
  }
  
  func test_receivingViewUnableToProcessEvent_pausesDataFetch() {
    test_cancellingEvent_pausesDataFetch {
      self.sut.viewDidChangeDataProcessingCapability(canProcessData: false)
    }
  }
  
  private func test_cancellingEvent_pausesDataFetch(cancelingEventClosure: @escaping () -> Void) {
    let expectation = XCTestExpectation(description: "cancellation closure called")
    var dataFetchCancelled = false
    exchangeRateServiceMock.exchangeRateCancelationClosure = {
      dataFetchCancelled = true
      expectation.fulfill()
    }
    exchangeRateServiceMock.exchangeRateResult = nil
    self.sut.startLoading()
    dispatch(cancelingEventClosure: cancelingEventClosure)
    wait(for: [expectation], timeout: 5)
    XCTAssertTrue(dataFetchCancelled)
  }
  
  private func dispatch(cancelingEventClosure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1200)) {
      cancelingEventClosure()
    }
  }
}
