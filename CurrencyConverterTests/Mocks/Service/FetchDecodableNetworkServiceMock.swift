//
//  Created by Ireneusz Sołek
//  

import Foundation
@testable import CurrencyConverter

class FetchDecodableNetworkServiceMock: FetchDecodableNetworkServiceProtocol {
  var mockResult: Result<Data, NetworkError>!
  func get<T>(url: URL, result: @escaping (Result<T, NetworkError>) -> ()) -> FetchDecodableNetworkServiceProtocol.CancelClosure where T : Decodable {
    switch mockResult {
    case .success(let data):
      let decodedObject = try! JSONDecoder().decode(T.self, from: data)
      result(.success(decodedObject))
    case .failure(let error):
      result(.failure(error))
    case .none:
      fatalError("set the mockResult property to use this mock")
    }
    return {}
  }
}
