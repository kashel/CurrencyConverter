//
//  Created by Ireneusz Sołek
//  

import UIKit

class ConverterCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  var lifecycle: ((CoordinatorLifecycleEvent) -> Void)?
  
  func start() -> UIViewController {
    let exchangeRateService = MockExchangeRatesService()
    let currencyPairService = CurrencyPairService()
    let viewModel = ConverterViewModel(currencyPairService: currencyPairService, exchangeRateService: exchangeRateService)
    return ConverterViewController(viewModel: viewModel, cellModelMapper: ExchangeRateCellModelMapper())
  }
}
