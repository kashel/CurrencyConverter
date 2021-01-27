//
//  Created by Ireneusz Sołek
//  

import Foundation

enum ExchangeRateServiceError: Error {
  case network(underlyingError: Error)
  case parsing
  case emptyResponse
}

protocol ExchangeRatesServiceFactory {
  var exchangeRatesService: ExchangeRatesServiceProtocol { get }
}

protocol ExchangeRatesServiceProtocol {
  typealias CancelClosure = () -> Void
  typealias LoadingCompleted =  (Result<[ExchangeRateModel], ExchangeRateServiceError>) -> Void
  func exchangeRates(currencyPairs: [CurrencyPair], completed: @escaping LoadingCompleted) -> CancelClosure
}

struct ExchangeRateService: ExchangeRatesServiceProtocol {
  let fetchDecodableNetworkService: FetchDecodableNetworkServiceProtocol
  let baseURL: String = "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios"
  let exchangeRatesDTOMapper: ExchangeRatesDTOMapperProtocol
  
  init(fetchDecodableNetworkService: FetchDecodableNetworkServiceProtocol = FetchDecodableNetworkService(), exchangeRatesDTOMapper: ExchangeRatesDTOMapperProtocol) {
    self.fetchDecodableNetworkService = fetchDecodableNetworkService
    self.exchangeRatesDTOMapper = exchangeRatesDTOMapper
  }
  
  func exchangeRates(currencyPairs: [CurrencyPair], completed: @escaping ExchangeRatesServiceProtocol.LoadingCompleted) -> ExchangeRatesServiceProtocol.CancelClosure {
    return fetchDecodableNetworkService.get(url: constructURL(with: currencyPairs)) { (result: Result<ExchangeRatesDTO, NetworkError>) in
      switch result {
        case .success(let exchangeRatesDTO):
          let models = exchangeRatesDTO.array.compactMap(exchangeRatesDTOMapper.map)
          guard models.count == exchangeRatesDTO.array.count else {
            completed(.failure(.parsing))
            return
          }
          let grouppedExchangeRates = Dictionary(grouping: models, by: {
            $0.sourceCurrency
          })
          let exchangeRatesWithOrder = currencyPairs.compactMap{ currencyPair in
            grouppedExchangeRates[currencyPair.send]?.first(where: { $0.receiveCurrency == currencyPair.receive })
          }
          completed(.success(exchangeRatesWithOrder))
      case .failure(let error):
        switch error {
        case .emptyResponse:
          completed(.failure(.emptyResponse))
        case .networkError(let networkError):
          completed(.failure(.network(underlyingError: networkError)))
        case .unableToDecodeJSON:
          completed(.failure(.parsing))
        }
        print(error)
      }
    }
  }
}

private extension ExchangeRateService {
  func constructURL(with currencyPairs: [CurrencyPair]) -> URL {
    let queryItems = currencyPairs.map{ URLQueryItem(name: "pairs", value: $0.send.code+$0.receive.code) }
    var urlComps = URLComponents(string: baseURL)!
    urlComps.queryItems = queryItems
    let result = urlComps.url!
    print(result)
    return result
  }
}
