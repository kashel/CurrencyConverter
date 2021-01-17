//
//  Created by Ireneusz Sołek
//  

import UIKit

class ConverterCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  
  func start() -> UIViewController {
    let initialParis = (1...20).map{ CurrencyPair(send: Currency(name: "sendCurrency_\($0)"), receive: Currency(name: "receiveCurrency_\($0)")) }
    let exchangeRateService = MockExchangeRatesService(currencyPairs: initialParis)
    let viewModel = ConverterViewModel(initialPairs: initialParis, exchangeRateService: exchangeRateService)
    return ConverterViewController(viewModel: viewModel, cellModelMapper: ExchangeRateCellModelMapper())
  }
}
