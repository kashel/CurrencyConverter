//
//  Created by Ireneusz Sołek
//  

import Foundation

extension ConverterViewController.EditState {
  func toggle() -> Self {
    switch self {
    case .editing:
      return .viewing
    case .viewing:
      return .editing
    }
  }
  
  var buttonTitle: String {
    switch self {
    case .editing:
      return L10n.done
    case .viewing:
      return L10n.edit
    }
  }
}
