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
    arguments.contains(CurrencyConverterLaunchArgument.automatedTestRun.rawValue)
  }
  
  var testRunLaunchScreen: LaunchScreen {
    arguments.contains(CurrencyConverterLaunchArgument.dashboardStartScreen.rawValue) ? .dashboard : .converter
  }
}
