//
//  Created by Ireneusz Sołek
//  

import UIKit

class ExchangeRateCellRow: UIView {
  struct AccessibilityIdentifiers {
    let lhs: AccessibilityIdentifier.Converter.ExchangeRateCell
    let rhs: AccessibilityIdentifier.Converter.ExchangeRateCell
  }
  let horizontalStack: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    return stackView
  }()
  
  var lhsLabel = UILabel()
  var rhsLabel = UILabel()
  
  let lhsDecorator: LabelDecorator
  let rhsDecorator: LabelDecorator
  
  init(lhsDecorator: LabelDecorator, rhsDecorator: LabelDecorator, accessibilityIdentifiers: AccessibilityIdentifiers) {
    self.lhsDecorator = lhsDecorator
    self.rhsDecorator = rhsDecorator
    super.init(frame: .zero)
    lhsLabel.accessibilityIdentifier = accessibilityIdentifiers.lhs.rawValue
    rhsLabel.accessibilityIdentifier = accessibilityIdentifiers.rhs.rawValue
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func willMove(toSuperview _: UIView?) {
    setupView()
  }
  
  private func setupView() {
    addSubview(horizontalStack)
    horizontalStack.pinEdges(to: self)
    horizontalStack.addArrangedSubview(lhsDecorator.decorate(label: lhsLabel))
    horizontalStack.addArrangedSubview(.horizontalSpacer)
    horizontalStack.addArrangedSubview(rhsLabel)
  }
  
  func configure(with model: ExchangeRateCellRowModel) {
    lhsLabel.text = model.lhsTile
    rhsLabel.text = model.rhsTitle
    rhsDecorator.decorate(label: rhsLabel)
  }
}
