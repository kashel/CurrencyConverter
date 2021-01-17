//
//  Created by Ireneusz Sołek
//  

import UIKit

extension UIView {
  static var verticalSpacer: UIView {
    let view = UIView()
    view.setContentHuggingPriority(.defaultLow, for: .vertical)
    return view
  }
  
  static var horizontalSpacer: UIView {
    let view = UIView()
    view.setContentHuggingPriority(.defaultLow, for: .horizontal)
    return view
  }
}
