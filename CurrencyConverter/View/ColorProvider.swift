//
//  Created by Ireneusz Sołek
//  

import UIKit

struct ColorProvider {
  var label: UIColor {
    UIColor(named: "label") ?? .green
  }
  
  var description: UIColor {
    UIColor(named: "description") ?? .darkGray
  }
  
  var link: UIColor {
    UIColor(named: "link") ?? .blue
  }
  
  var inactiveLink: UIColor {
    UIColor(named: "description") ?? .lightGray
  }
  
  var background: UIColor {
    UIColor(named: "background") ?? .clear
  }
}
