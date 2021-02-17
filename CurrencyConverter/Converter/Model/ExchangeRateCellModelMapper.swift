//
//  Created by Ireneusz Sołek
//  

import Foundation

protocol ExchangeRateCellModelMapperProtocol {
  func map(exchangeRate: ExchangeRateModel) -> ExchangeRateCellModel
}

struct ExchangeRateCellModelMapper: ExchangeRateCellModelMapperProtocol {
  let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 4
    formatter.maximumFractionDigits = 4
    formatter.roundingMode = .halfUp
    return formatter
  }()
  
  func map(exchangeRate: ExchangeRateModel) -> ExchangeRateCellModel {
    let exchangeRateValue = numberFormatter.string(from: exchangeRate.receiveAmount as NSDecimalNumber)
    let title = ExchangeRateCellRowModel(lhsTile: "1 \(exchangeRate.sourceCurrency.code)",
                                         rhsTitle: exchangeRateValue ?? "")
    let description = ExchangeRateCellRowModel(lhsTile: "\(exchangeRate.sourceCurrency.name)",
                                               rhsTitle: "\(exchangeRate.receiveCurrency.name) · \(exchangeRate.receiveCurrency.code)")
    return ExchangeRateCellModel(title: title, description: description)
  }
}
