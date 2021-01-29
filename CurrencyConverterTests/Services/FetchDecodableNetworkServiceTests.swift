//
//  Created by Ireneusz Sołek
//  

import XCTest
@testable import CurrencyConverter

class FetchDecodableNetworkServiceTests: XCTestCase {
  struct DecodableMock: Decodable {
    let name: String
  }
  
  let decodableMockJSON = """
  {
     "name": "John Doe"
  }
"""
  
  var urlSessionMock: URLSessionMock!
  var sut: FetchDecodableNetworkService!
  let mockURL = URL(string: "http://localhost")!
  
  override func setUp() {
    urlSessionMock = URLSessionMock()
    sut = FetchDecodableNetworkService(urlSession: urlSessionMock)
    super.setUp()
  }
  
  func test_decodableData_isDecodedCorrectly() {
    urlSessionMock.data = decodableMockJSON.data(using: .utf8)
    var result: Result<DecodableMock, NetworkError>?
    _ = sut.get(url: mockURL) {
      result = $0
    }
    guard case .success(let decodableObject) = result, decodableObject.name == "John Doe" else {
      XCTFail("Unable to decode decodable object")
      return
    }
  }
  
  func test_emptyServerResponse_producesEmptyResponseError() {
    urlSessionMock.data = nil
    var result: Result<DecodableMock, NetworkError>?
    _ = sut.get(url: mockURL) {
      result = $0
    }
    guard case .failure(let error) = result, case .emptyResponse = error else {
      XCTFail("Parsing empty response should produce .emptyResponse error ")
      return
    }
  }
  
  func test_networkErrorServerResponse_producesNetworkError() {
    urlSessionMock.error = NSError(domain: "", code: 404, userInfo: nil)
    var result: Result<DecodableMock, NetworkError>?
    
    _ = sut.get(url: mockURL) {
      result = $0
    }
    guard case .failure(let networkError) = result, case .networkError = networkError else {
      XCTFail("Parsing empty response should produce .network error ")
      return
    }
  }
  
  func test_cancelationClosure_cancelsOngoingTask() {
    urlSessionMock.data = decodableMockJSON.data(using: .utf8)
    let cancelable = sut.get(url: mockURL) { (result: Result<DecodableMock, NetworkError>) in }
    cancelable()
    
    guard let dataTaskMock = urlSessionMock.dataTaskMock else {
      XCTFail()
      return
    }
    XCTAssertTrue(dataTaskMock.cancelCalled)
  }
}
