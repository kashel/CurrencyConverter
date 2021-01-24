//
//  Created by Ireneusz Sołek
//  

import Foundation

class MockUserDefaults: UserDefaults {
  init(suiteName: String) {
    super.init(suiteName: suiteName)!
    removePersistentDomain(forName: suiteName)
  }
  
  var setValueCalledWithValue: Any?
  override func setValue(_ value: Any?, forKey key: String) {
    setValueCalledWithValue = value
  }
  
  override func set(_ value: Any?, forKey defaultName: String) {
    setValueCalledWithValue = value
  }
  
  var objectForKeyCalledForKey: String?
  var mockObjectForKey: Any?
  override func object(forKey defaultName: String) -> Any? {
    objectForKeyCalledForKey = defaultName
    return mockObjectForKey
  }
}
