//
//  Created by Ireneusz Sołek
//  

import UIKit

class ExchangeRateCellRow: UIView {
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
  
  override func willMove(toSuperview _: UIView?) {
    setupView()
  }
  
  private func setupView() {
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
