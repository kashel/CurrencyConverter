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
          exchangeRatesFetched(currencyPairs: currencyPairs, exchangeRatesDTO: exchangeRatesDTO, completed: completed)
      case .failure(let error):
        fetchingFailed(error: error, completed: completed)
      }
    }
  }
}

private extension ExchangeRateService {
  func exchangeRatesFetched(currencyPairs: [CurrencyPair], exchangeRatesDTO: ExchangeRatesDTO, completed: @escaping ExchangeRatesServiceProtocol.LoadingCompleted) {
    let models = exchangeRatesDTO.array.compactMap(exchangeRatesDTOMapper.map)
    if models.count != exchangeRatesDTO.array.count {
      completed(.failure(.parsing))
      return
    }
    let grouppedExchangeRates = Dictionary(grouping: models) { $0.sourceCurrency }
    let exchangeRatesWithOrder = currencyPairs.compactMap { currencyPair in
      grouppedExchangeRates[currencyPair.send]?.first(where: { $0.receiveCurrency == currencyPair.receive })
    }
    completed(.success(exchangeRatesWithOrder))
  }
  
  func fetchingFailed(error: NetworkError, completed: @escaping ExchangeRatesServiceProtocol.LoadingCompleted) {
    switch error {
    case .emptyResponse:
      completed(.failure(.emptyResponse))
    case .networkError(let networkError):
      completed(.failure(.network(underlyingError: networkError)))
    case .unableToDecodeJSON:
      completed(.failure(.parsing))
    }
  }
  
  func constructURL(with currencyPairs: [CurrencyPair]) -> URL {
    let queryItems = currencyPairs.map { URLQueryItem(name: "pairs", value: $0.send.code + $0.receive.code) }
    var urlComps = URLComponents(string: baseURL)!
    urlComps.queryItems = queryItems
    let result = urlComps.url!
    return result
  }
}
