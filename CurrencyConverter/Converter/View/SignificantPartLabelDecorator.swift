//
//  Created by Ireneusz Sołek
//  

import UIKit

struct SignificantPartLabelDecorator: LabelDecorator {
  struct Style {
    let significantPartFont: UIFont
    let minorPartFont: UIFont
    let color: UIColor
  }
  let style: Style
  let significantPartAttributes: [NSAttributedString.Key: Any]
  
  init(style: Style) {
    self.style = style
    self.significantPartAttributes = [.foregroundColor: style.color, .font: style.significantPartFont]
  }
  
  func decorate(label: UILabel) -> UILabel {
    guard let text = label.text else {
      return label
    }
    
    let attributedText = NSMutableAttributedString(string: text, attributes: significantPartAttributes)
    attributedText.addAttribute(.font, value: style.minorPartFont, range: NSRange(location: text.count - 2, length: 2))
    label.attributedText = attributedText
    return label
  }
}
