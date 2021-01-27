//
//  Created by Ireneusz Sołek
//  

import Foundation

public enum LaunchScreen {
  case dashboard
  case converter
}

extension ProcessInfo {
  var isUITestRun: Bool {
    return self.arguments.contains(CurrencyConverterLaunchArgument.automatedTestRun.rawValue)
  }
  
  var testRunLaunchScreen: LaunchScreen {
    if self.arguments.contains(CurrencyConverterLaunchArgument.dashboardStartScreen.rawValue) {
      return .dashboard
    }
    return .converter
  }
}
