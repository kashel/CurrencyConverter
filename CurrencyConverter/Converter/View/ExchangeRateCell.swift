//
//  Created by Ireneusz Sołek
//  

import UIKit

class ExchangeRateCell: UITableViewCell {
  struct Constants {
    static let margin: CGFloat = 16
    static let rowsSpacing: CGFloat = 6
  }
  let colorProvider = ColorProvider()
  let fontProvider = FontProvider()
  
  lazy var titleLeft = ExchangeRateCellRow.Style.Label(textColor: colorProvider.label, font: fontProvider.cellTitle)
  lazy var titleRight = ExchangeRateCellRow.Style.Label(textColor: colorProvider.label, font: fontProvider.cellTitle)
  lazy var descriptionStyle = ExchangeRateCellRow.Style.Label(textColor: colorProvider.description, font: fontProvider.cellDescription)
  lazy var titleRow: ExchangeRateCellRow = ExchangeRateCellRow(style: ExchangeRateCellRow.Style(lhsLabel: titleLeft, rhsLabel: titleRight))
  lazy var descriptionRow: ExchangeRateCellRow = ExchangeRateCellRow(style: ExchangeRateCellRow.Style(lhsLabel: descriptionStyle, rhsLabel: descriptionStyle))
  let verticalStack: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = Constants.rowsSpacing
    return stackView
  }()
  
  override func willMove(toSuperview _: UIView?) {
    setupView()
  }
  
  private func setupView() {
    addSubview(verticalStack)
    verticalStack.translatesAutoresizingMaskIntoConstraints = false
    verticalStack.pinEdges(to: self, offsets: UIEdgeInsets(top: Constants.margin, left: Constants.margin, bottom: -Constants.margin, right: -Constants.margin))
    verticalStack.addArrangedSubview(titleRow)
    verticalStack.addArrangedSubview(descriptionRow)
  }

  func configure(with model: ExchangeRateCellModel) {
    titleRow.configure(with: model.title)
    descriptionRow.configure(with: model.description)
  }
}
