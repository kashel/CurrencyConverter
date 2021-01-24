//
//  Created by Ireneusz Sołek
//  

import Foundation

struct L10n {
  static let addCurrencyPair = L10n.tr("addCurrencyPair")
  static let edit = L10n.tr("edit")
  static let done = L10n.tr("done")
  static let sendCurrency = L10n.tr("sendCurrency")
  static let receiveCurrency = L10n.tr("receiveCurrency")
  static let chooseCurrencyPair = L10n.tr("chooseCurrencyPair")
}

extension L10n {
  private static func tr(_ key: String, table: String = "Localizable", args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
