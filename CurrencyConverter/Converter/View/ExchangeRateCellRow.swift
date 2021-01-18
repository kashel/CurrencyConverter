//
//  Created by Ireneusz Sołek
//  

import UIKit

class ExchangeRateCellRow: UIView {
  struct Style {
    struct Label {
      let textColor: UIColor
      let font: UIFont
    }
    let lhsLabel: Label
    let rhsLabel: Label
  }
  
  let horizontalStack: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    return stackView
  }()
  
  let lhsLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let rhsLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let style: Style
  
  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func willMove(toSuperview _: UIView?) {
    setupView()
  }
  
  private func setupView() {
    lhsLabel.textColor = style.lhsLabel.textColor
    lhsLabel.font = style.lhsLabel.font
    rhsLabel.textColor = style.rhsLabel.textColor
    rhsLabel.font = style.rhsLabel.font
    addSubview(horizontalStack)
    horizontalStack.pinEdges(to: self)
    horizontalStack.addArrangedSubview(lhsLabel)
    horizontalStack.addArrangedSubview(.horizontalSpacer)
    horizontalStack.addArrangedSubview(rhsLabel)
  }
  
  func configure(with model: ExchangeRateCellRowModel) {
    lhsLabel.text = model.lhsTile
    rhsLabel.attributedText = model.rhsTitle
  }
}
