//
//  Created by Ireneusz Sołek
//  
import Foundation
import os.log

extension OSLog {
  private static var subsystem = Bundle.main.bundleIdentifier!

  static let data = OSLog(subsystem: subsystem, category: "data")
  static let debug = OSLog(subsystem: subsystem, category: "debug")
}
