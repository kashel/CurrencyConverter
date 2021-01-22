//
//  Created by Ireneusz Sołek
//  

import UIKit

protocol LabelDecorator {
  @discardableResult func decorate(label: UILabel) -> UILabel
}

struct StandardLabelDecorator: LabelDecorator {
  struct Style {
    let font: UIFont
    let color: UIColor
  }
  let style: Style
  
  func decorate(label: UILabel) -> UILabel {
    label.textColor = style.color
    label.font = style.font
    return label
  }
}
