//
//  Created by Ireneusz Sołek
//  

import Foundation

public enum NetworkError: Error {
  case httpErrorWithCode(Int)
  case unableToDecodeJSON
  case networkError(Error)
  case other
  case emptyResponse
}

public protocol FetchDecodableNetworkServiceProtocol {
  func get<T: Decodable>(url: URL, result: @escaping (Result<T, NetworkError>) -> ())
}

public final class FetchDecodableNetworkService: FetchDecodableNetworkServiceProtocol {
  public init() {}
  
  public func get<T: Decodable>(url: URL, result: @escaping (Result<T, NetworkError>) -> ()) {
    let session = URLSession.shared
    let task = session.dataTask(with: url) { (data, response, error) in
      if let error = error {
        result(.failure(.networkError(error)))
        return
      }
      guard let response = response as? HTTPURLResponse else {
        result(.failure(.other))
        return
      }
      guard (200...299).contains(response.statusCode) else {
        result(.failure(.httpErrorWithCode(response.statusCode)))
        return
      }
      guard let data = data else {
        result(.failure(.emptyResponse))
        return
      }
      guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
        result(.failure(.unableToDecodeJSON))
        return
      }
      result(.success(decoded))
    }
    task.resume()
  }
}
