//
//  Created by Ireneusz Sołek
//  

import UIKit

struct Currency: Codable, Equatable, Hashable {
  let code: String
  let countryCode: String
}

extension Currency {
  var name: String {
    Locale.current.localizedString(forCurrencyCode: code) ?? ""
  }
  
  var flag: UIImage {
    UIImage(named: countryCode) ?? UIImage()
  }
}
