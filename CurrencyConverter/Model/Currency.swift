//
//  Created by Ireneusz Sołek
//  

import UIKit

struct Currency {
  let code: String
  let countryCode: String
}

extension Currency {
  var name: String {
    return Locale.current.localizedString(forCurrencyCode: code) ?? ""
  }
  
  var flag: UIImage {
    return UIImage(named: countryCode) ?? UIImage()
  }
}
