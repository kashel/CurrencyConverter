//
//  Created by Ireneusz Sołek
//  

import Foundation

class MockError: Error {
  let code: Int
  init(code: Int) {
    self.code = code
  }
}
