//
//  Created by Ireneusz Sołek
//  

import XCTest
@testable import CurrencyConverter

class ExchangeRatesServiceTests: XCTestCase {
  var fetchDecodableMock: FetchDecodableNetworkServiceMock!
  var exchangeRatesDTOMapperMock: ExchangeRatesDTOMapperMock!
  var sut: ExchangeRateService!
  
  override func setUp() {
    fetchDecodableMock = FetchDecodableNetworkServiceMock()
    exchangeRatesDTOMapperMock = ExchangeRatesDTOMapperMock()
    sut = ExchangeRateService(fetchDecodableNetworkService: fetchDecodableMock, exchangeRatesDTOMapper: exchangeRatesDTOMapperMock)
    super.setUp()
  }
  
  func test_emptyNetoworkResponse_producesNetworkError() {
    fetchDecodableMock.mockResult = .failure(.emptyResponse)
    var emptyResponseErrorReturned = false
    _ = sut.exchangeRates(currencyPairs: []) { (result) in
      if case .failure(let error) = result, case .emptyResponse = error {
        emptyResponseErrorReturned = true
      }
    }
    XCTAssertTrue(emptyResponseErrorReturned)
  }
  
  func test_errorNetowrkResponse_producesNetworkError() {
    let networkError = MockError(code: 999)
    fetchDecodableMock.mockResult = .failure(.networkError(networkError))
    var exchangeRateNetworkError: Error?
    _ = sut.exchangeRates(currencyPairs: []) { (result) in
      switch result {
      case .failure(let error):
        switch error {
        case .network(let networkError):
          exchangeRateNetworkError = networkError
        default:
          print("continue")
        }
      case .success:
        print("continue")
      }
    }
    guard let mockError = exchangeRateNetworkError as? MockError, mockError.code == 999 else {
      XCTFail("expected error response with .emptyResponse network error")
      return
    }
  }
  
  func test_contractBreach_producesParsingError() {
    fetchDecodableMock.mockResult = .failure(.unableToDecodeJSON)
    var parsingErrorReturned = false
    _ = sut.exchangeRates(currencyPairs: []) { (result) in
      switch result {
      case .failure(let error):
        switch error {
        case .parsing:
          parsingErrorReturned = true
        default:
          print("continue")
        }
      case .success:
        print("continue")
      }
    }
    XCTAssertTrue(parsingErrorReturned)
  }
  
  private let successJSON = """
    {
      "USDPLN": 1.1554
    }
    """
  
  private lazy var successData: Data = {
    successJSON.data(using: .utf8)!
  }()
  
  func test_successResponse_isPassedToMapper() {
    fetchDecodableMock.mockResult = .success(successData)
    exchangeRatesDTOMapperMock.mockModel = ExchangeRateModel(sourceCurrency: .usDolar, sourceAmount: 0, receiveCurrency: .polishZloty, receiveAmount: 0)
    _ = sut.exchangeRates(currencyPairs: [CurrencyPair.mock]) { _ in }
    XCTAssertNotNil(exchangeRatesDTOMapperMock.mapCalledForDTOCalled)
  }
  
  func test_successResponse_isCorrectlyParsed() {
    fetchDecodableMock.mockResult = .success(successData)
    exchangeRatesDTOMapperMock.mockModel = ExchangeRateModel(sourceCurrency: .usDolar, sourceAmount: 0, receiveCurrency: .polishZloty, receiveAmount: 0)
    
    var parsedObjects: [ExchangeRateModel] = []
    _ = sut.exchangeRates(currencyPairs: [CurrencyPair.mock]) { (result) in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let models):
        parsedObjects = models
      }
    }
    XCTAssertEqual(parsedObjects.first!.sourceCurrency, .usDolar)
    XCTAssertEqual(parsedObjects.first!.receiveCurrency, .polishZloty)
    XCTAssertEqual(parsedObjects.first!.sourceAmount, 0)
    XCTAssertEqual(parsedObjects.first!.receiveAmount, 0)
  }
}
