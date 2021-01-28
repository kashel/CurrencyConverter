//
//  Created by Ireneusz Sołek
//  

import Foundation

public enum TestAAA: String {
  case aaa
}

public struct AccessibilityIdentifier {
  public struct Dashboard {
    public static let addCurrencyPairIconButton = "dashboard.addCurrencyPairIconButton"
    public static let addCurrencyPairButton = "dashboard.addCurrencyPairButton"
    public static let chooseCurrencyPairDescription = "dashboard.chooseCurrencyPairDescription"
  }
  public struct Converter {
    public struct ExchangeRateCell {
      public static let sourceCurrencyCode = "converter.exchangeRateCell.sourceCurrencyCode"
      public static let exchangeRate = "converter.exchangeRateCell.exchangeRate"
      public static let sourceCurrencyName = "converter.exchangeRateCell.sourceCurrencyName"
      public static let receiveCurrencyNameAndCode = "converter.exchangeRateCell.receiveCurrencyNameAndCode"
    }
    public static let addCurrencyPairButton = "converter.addCurrencyPairButton"
    public static let editButton = "converter.editButton"
    public static let deleteButton = "converter.delete"
  }
}
