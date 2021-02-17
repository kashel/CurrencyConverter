//
//  Created by Ireneusz Sołek
//  

import Foundation

class URLSessionDataTaskMock: URLSessionDataTask {
  private let closure: () -> Void
  
  init(closure: @escaping () -> Void) {
    self.closure = closure
  }
  
  override func resume() {
    closure()
  }
  
  var cancelCalled: Bool = false
  override func cancel() {
    cancelCalled = true
  }
}
