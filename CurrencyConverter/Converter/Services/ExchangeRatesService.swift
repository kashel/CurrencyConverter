//
//  Created by Ireneusz Sołek
//  

import Foundation

enum ExchangeRateServiceError: Error {
  case network
  case parsing
}

protocol ExchangeRatesServiceProtocol {
  typealias LoadingCompleted =  (Result<[ExchangeRateModel], ExchangeRateServiceError>) -> Void
  func exchangeRates(currencyPairs: [CurrencyPair], completed: @escaping LoadingCompleted)
}

struct MockExchangeRatesService: ExchangeRatesServiceProtocol {
  var currencyPairs: [CurrencyPair] = []
  func exchangeRates(currencyPairs: [CurrencyPair], completed: ExchangeRatesServiceProtocol.LoadingCompleted) {
    let exchangeRates = currencyPairs.map { currencyPair in
      ExchangeRateModel(sourceCurrency: currencyPair.send,
                        sourceAmount: 1,
                        receiveCurrency: currencyPair.receive, receiveAmount: 1.2345)
    }
    
    completed(.success(exchangeRates))
  }
}

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

struct ExchangeRateService: ExchangeRatesServiceProtocol {
  let fetchDecodableNetworkService: FetchDecodableNetworkServiceProtocol
  let baseURL: String = "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios"
  let mapper = ExchangeRatesDTOMapper()
  
  init(fetchDecodableNetworkService: FetchDecodableNetworkServiceProtocol = FetchDecodableNetworkService()) {
    self.fetchDecodableNetworkService = fetchDecodableNetworkService
  }
  
  func exchangeRates(currencyPairs: [CurrencyPair], completed: @escaping ExchangeRatesServiceProtocol.LoadingCompleted) {
    fetchDecodableNetworkService.get(url: constructURL(with: currencyPairs)) { (result: Result<ExchangeRatesDTO, NetworkError>) in
      switch result {
        case .success(let exchangeRatesDTO):
          let models = exchangeRatesDTO.array.map(mapper.map)
          let grouppedExchangeRates = Dictionary(grouping: models, by: {
            $0.sourceCurrency
          })
          let exchangeRatesWithOrder = currencyPairs.compactMap{ currencyPair in
            grouppedExchangeRates[currencyPair.send]?.first(where: { $0.receiveCurrency == currencyPair.receive })
          }
          completed(.success(exchangeRatesWithOrder))
      case .failure(let error):
        print(error)
      }
    }
  }
  
  private func constructURL(with currencyPairs: [CurrencyPair]) -> URL {
    let queryItems = currencyPairs.map{ URLQueryItem(name: "pairs", value: $0.send.code+$0.receive.code) }
    var urlComps = URLComponents(string: baseURL)!
    urlComps.queryItems = queryItems
    let result = urlComps.url!
    print(result)
    return result
  }
}

struct ExchangeRatesDTOMapper {
  let currencyService = CurrencySerive()
  func map(dto: ExchangeRateDTO) -> ExchangeRateModel {
    let sendCurrencyCode = String(dto.currencySymbolsPair.prefix(3)).uppercased()
    let receiveCurrencyCode = String(dto.currencySymbolsPair.suffix(3)).uppercased()
    
    
    guard let sendCurrency = currencyService.findAvailableCurrency(by: sendCurrencyCode), let receiveCurrency = currencyService.findAvailableCurrency(by: receiveCurrencyCode) else {
      fatalError()
    }
    
    return ExchangeRateModel(sourceCurrency: sendCurrency, sourceAmount: 1, receiveCurrency: receiveCurrency, receiveAmount: dto.exchangeRate)
  }
}
