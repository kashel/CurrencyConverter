//
//  Created by Ireneusz Sołek
//  

import Foundation

public enum TestAAA: String {
  case aaa
}

public struct AccessibilityIdentifier {
  public enum Dashboard: String {
    case addCurrencyPairIconButton = "dashboard.addCurrencyPairIconButton"
    case addCurrencyPairButton = "dashboard.addCurrencyPairButton"
    case chooseCurrencyPairDescription = "dashboard.chooseCurrencyPairDescription"
  }
  public enum Converter {
    public enum ExchangeRateCell: String {
      case sourceCurrencyCode = "converter.exchangeRateCell.sourceCurrencyCode"
      case exchangeRate = "converter.exchangeRateCell.exchangeRate"
      case sourceCurrencyName = "converter.exchangeRateCell.sourceCurrencyName"
      case receiveCurrencyNameAndCode = "converter.exchangeRateCell.receiveCurrencyNameAndCode"
    }
    public enum Button: String {
      case addCurrencyPair = "converter.addCurrencyPairButton"
      case edit = "converter.editButton"
      case delete = "converter.delete"
    }
  }
}
