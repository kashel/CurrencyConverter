//
//  Created by Ireneusz Sołek
//  

import Foundation

enum ExchangeRateServiceError: Error {
  case network(underlyingError: NetworkError)
  case parsing
}

protocol ExchangeRatesServiceProtocol {
  typealias CancelClosure = () -> Void
  typealias LoadingCompleted =  (Result<[ExchangeRateModel], ExchangeRateServiceError>) -> Void
  func exchangeRates(currencyPairs: [CurrencyPair], completed: @escaping LoadingCompleted) -> CancelClosure
}

struct ExchangeRateService: ExchangeRatesServiceProtocol {
  let fetchDecodableNetworkService: FetchDecodableNetworkServiceProtocol
  let baseURL: String = "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios"
  let mapper = ExchangeRatesDTOMapper(currencyService: CurrencyService())
  
  init(fetchDecodableNetworkService: FetchDecodableNetworkServiceProtocol = FetchDecodableNetworkService()) {
    self.fetchDecodableNetworkService = fetchDecodableNetworkService
  }
  
  func exchangeRates(currencyPairs: [CurrencyPair], completed: @escaping ExchangeRatesServiceProtocol.LoadingCompleted) -> ExchangeRatesServiceProtocol.CancelClosure {
    return fetchDecodableNetworkService.get(url: constructURL(with: currencyPairs)) { (result: Result<ExchangeRatesDTO, NetworkError>) in
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
        switch error {
        case .emptyResponse, .networkError:
          completed(.failure(.network(underlyingError: error)))
        case .unableToDecodeJSON:
          completed(.failure(.parsing))
        }
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
