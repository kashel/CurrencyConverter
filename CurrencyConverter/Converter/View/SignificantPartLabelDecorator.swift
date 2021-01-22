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
  let minorPartLength: Int
  
  init(style: Style, minorPartLength: Int) {
    self.style = style
    self.significantPartAttributes = [.foregroundColor: style.color, .font: style.significantPartFont]
    self.minorPartLength = minorPartLength
  }
  
  func decorate(label: UILabel) -> UILabel {
    guard let text = label.text else {
      return label
    }
    let attributedText = NSMutableAttributedString(string: text, attributes: significantPartAttributes)
    if text.count > minorPartLength {
      attributedText.addAttribute(.font, value: style.minorPartFont, range: NSRange(location: text.count - minorPartLength, length: minorPartLength))
    }
    label.attributedText = attributedText
    return label
  }
}
