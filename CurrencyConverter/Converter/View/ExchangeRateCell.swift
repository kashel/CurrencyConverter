//
//  Created by Ireneusz Sołek
//  

import UIKit

class ExchangeRateCell: UITableViewCell {
  typealias Style = StandardLabelDecorator.Style
  struct Constants {
    static let margin: CGFloat = 16
    static let rowsSpacing: CGFloat = 6
  }
  
  let colorProvider = ColorProvider()
  let fontProvider = FontProvider()
  
  lazy var titleDecorator = StandardLabelDecorator(style: Style(font: fontProvider.cellTitle, color: colorProvider.label))
  lazy var descriptionDecorator = StandardLabelDecorator(style: Style(font: fontProvider.cellDescription, color: colorProvider.description))
  lazy var significantPartDecorator = SignificantPartLabelDecorator(style: SignificantPartLabelDecorator.Style(significantPartFont: fontProvider.cellTitle,
                                                                                                               minorPartFont: fontProvider.cellTitleMinor,
                                                                                                               color: colorProvider.label),
                                                                    minorPartLength: 2)
  lazy var titleRowAccessibilityIdentifiers = ExchangeRateCellRow.AccessibilityIdentifiers(lhs: AccessibilityIdentifier.Converter.ExchangeRateCell.sourceCurrencyCode,
                                                                                           rhs: AccessibilityIdentifier.Converter.ExchangeRateCell.exchangeRate)
  lazy var descriptionRowAccessibilityIdentifiers = ExchangeRateCellRow.AccessibilityIdentifiers(lhs: AccessibilityIdentifier.Converter.ExchangeRateCell.sourceCurrencyName,
                                                                                                 rhs: AccessibilityIdentifier.Converter.ExchangeRateCell.receiveCurrencyNameAndCode)
  lazy var titleRow: ExchangeRateCellRow = ExchangeRateCellRow(lhsDecorator: titleDecorator, rhsDecorator: significantPartDecorator, accessibilityIdentifiers: titleRowAccessibilityIdentifiers)
  lazy var descriptionRow: ExchangeRateCellRow = ExchangeRateCellRow(lhsDecorator: descriptionDecorator, rhsDecorator: descriptionDecorator, accessibilityIdentifiers: descriptionRowAccessibilityIdentifiers)
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
    contentView.addSubview(verticalStack)
    verticalStack.translatesAutoresizingMaskIntoConstraints = false
    verticalStack.pinEdges(to: contentView, offsets: UIEdgeInsets(top: Constants.margin, left: Constants.margin, bottom: -Constants.margin, right: -Constants.margin), priority: .defaultLow)
    verticalStack.addArrangedSubview(titleRow)
    verticalStack.addArrangedSubview(descriptionRow)
  }
  
  func configure(with model: ExchangeRateCellModel) {
    titleRow.configure(with: model.title)
    descriptionRow.configure(with: model.description)
  }
}
