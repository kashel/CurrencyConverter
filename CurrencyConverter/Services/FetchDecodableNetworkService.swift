//
//  Created by Ireneusz Sołek
//  

import Foundation

public enum NetworkError: Error {
  case unableToDecodeJSON
  case networkError(Error)
  case emptyResponse
}

public protocol FetchDecodableNetworkServiceProtocol {
  typealias CancelClosure = () -> Void
  func get<T: Decodable>(url: URL, result: @escaping (Result<T, NetworkError>) -> ()) -> CancelClosure
}

public final class FetchDecodableNetworkService: FetchDecodableNetworkServiceProtocol {
  public init() {}
  private var ongoingTask: URLSessionTask!
  
  public func get<T: Decodable>(url: URL, result: @escaping (Result<T, NetworkError>) -> ()) -> FetchDecodableNetworkServiceProtocol.CancelClosure {
    let session = URLSession.shared
    ongoingTask = session.dataTask(with: url) { (data, _, error) in
      if let error = error {
        result(.failure(.networkError(error)))
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
    ongoingTask.resume()
    return {
      self.ongoingTask.cancel()
    }
  }
}
