//
//  Created by Ireneusz Sołek
//  

import UIKit

struct FontProvider {
  func basicFont(size: CGFloat) -> UIFont {
    UIFont(name: "Roboto-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
  }
  
  var button: UIFont {
    basicFont(size: 16)
  }
  
  var title: UIFont {
    basicFont(size: 20)
  }
  
  var subtitle: UIFont {
    basicFont(size: 14)
  }
  
  var cellTitle: UIFont {
    basicFont(size: 20)
  }
  
  var cellTitleMinor: UIFont {
    basicFont(size: 14)
  }
  
  var cellDescription: UIFont {
    basicFont(size: 14)
  }
  
  var currencySymbol: UIFont {
    basicFont(size: 16)
  }
  
  var currencyName: UIFont {
    basicFont(size: 16)
  }
}
