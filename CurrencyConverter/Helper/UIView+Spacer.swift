//
//  Created by Ireneusz Sołek
//  

import UIKit

extension UIView {  
  static var horizontalSpacer: UIView {
    let view = UIView()
    view.setContentHuggingPriority(.defaultLow, for: .horizontal)
    return view
  }
}
