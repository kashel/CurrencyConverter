//
//  Created by Ireneusz Sołek
//  

import Foundation

class URLSessionMock: URLSession {
  typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
  var data: Data?
  var error: Error?
  var dataTaskMock: URLSessionDataTaskMock?
  
  override func dataTask(
    with url: URL,
    completionHandler: @escaping CompletionHandler
  ) -> URLSessionDataTask {
    let data = self.data
    let error = self.error
    
    dataTaskMock = URLSessionDataTaskMock {
      completionHandler(data, nil, error)
    }
    return dataTaskMock!
  }
}
