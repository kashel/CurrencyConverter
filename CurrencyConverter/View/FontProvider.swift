//
//  Created by Ireneusz Sołek
//  

import UIKit

struct FontProvider {
  func basicFont(with size: CGFloat) -> UIFont {
    UIFont(name: "Roboto-Regular", size: size) ?? UIFont.systemFont(ofSize: 12)
  }
  
  var button: UIFont {
    basicFont(with: 16)
  }
  
  var title: UIFont {
    basicFont(with: 20)
  }
  
  var subtitle: UIFont {
    basicFont(with: 14)
  }
  
  var cellTitle: UIFont {
    basicFont(with: 20)
  }
  
  var cellTitleMinor: UIFont {
    basicFont(with: 14)
  }
  
  var cellDescription: UIFont {
    basicFont(with: 14)
  }
  
  var currencySymbol: UIFont {
    basicFont(with: 16)
  }
  
  var currencyName: UIFont {
    basicFont(with: 16)
  }
}
