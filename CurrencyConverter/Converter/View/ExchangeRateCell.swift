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
  
  lazy var titleDecorator = StandardLabelDecorator(style: StandardLabelDecorator.Style(font: fontProvider.cellTitle, color: colorProvider.label))
  lazy var descriptionDecorator = StandardLabelDecorator(style: StandardLabelDecorator.Style(font: fontProvider.cellDescription, color: colorProvider.description))
  lazy var significantPartDecorator = SignificantPartLabelDecorator(style: SignificantPartLabelDecorator.Style(significantPartFont: fontProvider.cellTitle, minorPartFont: fontProvider.cellTitleMinor, color: colorProvider.label), minorPartLength: 2)

  lazy var titleRow: ExchangeRateCellRow = ExchangeRateCellRow(lhsDecorator: titleDecorator, rhsDecorator: significantPartDecorator)
  lazy var descriptionRow: ExchangeRateCellRow = ExchangeRateCellRow(lhsDecorator: descriptionDecorator, rhsDecorator: descriptionDecorator)
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
