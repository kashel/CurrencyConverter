//
//  Created by Ireneusz Sołek
//  

import UIKit

struct ColorProvider {
  var label: UIColor {
    UIColor(named: "label") ?? .green
  }
  
  var description: UIColor {
    UIColor(named: "description") ?? .red
  }
  
  var link: UIColor {
    UIColor(named: "link") ?? .orange
  }
}
