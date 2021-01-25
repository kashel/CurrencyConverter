//
//  Created by Ireneusz Sołek
//  

import Foundation

extension ProcessInfo {
  var isUITestRun: Bool {
    return self.arguments.contains(CurrencyConverterLaunchArgument.automatedTestRun.rawValue)
  }
}
