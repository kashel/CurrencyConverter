//
//  Created by Ireneusz Sołek
//  

import Foundation

protocol ExchangeRateCellModelMapperProtocol {
  func map(exchangeRate: ExchangeRateModel) -> ExchangeRateCellModel
}

struct ExchangeRateCellModelMapper: ExchangeRateCellModelMapperProtocol {
  func map(exchangeRate: ExchangeRateModel) -> ExchangeRateCellModel {
    let title = ExchangeRateCellRowModel(lhsTile: "1 \(exchangeRate.sourceCurrency.name)",
                                         rhsTitle: NSAttributedString(string: "\(exchangeRate.receiveAmount)"))
    let description = ExchangeRateCellRowModel(lhsTile: "\(exchangeRate.sourceCurrency.name)",
                                               rhsTitle: NSAttributedString(string: "\(exchangeRate.receiveCurrency.name)"))
    return ExchangeRateCellModel(title: title, description: description)
  }
}
