//
//  Created by Ireneusz Sołek
//  

import UIKit

class ExchangeRateCell: UITableViewCell {
  let titleRow: ExchangeRateCellRow = ExchangeRateCellRow()
  let descriptionRow: ExchangeRateCellRow = ExchangeRateCellRow()
  let verticalStack: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    return stackView
  }()
  
  override func willMove(toSuperview _: UIView?) {
    setupView()
  }
  
  private func setupView() {
    addSubview(verticalStack)
    verticalStack.translatesAutoresizingMaskIntoConstraints = false
    verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    verticalStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
    verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    verticalStack.addArrangedSubview(titleRow)
    verticalStack.addArrangedSubview(descriptionRow)
  }

  func configure(with model: ExchangeRateCellModel) {
    titleRow.configure(with: model.title)
    descriptionRow.configure(with: model.description)
  }
}
