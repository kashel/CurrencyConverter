//
//  Created by Ireneusz Sołek
//  

import UIKit

struct CurrencySelectionCellModel {
  let currencyName: String
  let currencyCode: String
  let icon: UIImage
  let isSelectable: Bool
}

class CurrencySelectionCell: UITableViewCell {
  struct Constants {
    static let iconSize: CGFloat = 24
    static let margin: CGFloat = 16
  }
  let fontProvider = FontProvider()
  let colorProvider = ColorProvider()
  
  lazy var currencyName: UILabel = {
    let label = UILabel()
    label.font = fontProvider.currencyName
    label.textColor = colorProvider.label
    return label
  }()
  
  lazy var currencyCode: UILabel = {
    let label = UILabel()
    label.font = fontProvider.currencySymbol
    label.textColor = colorProvider.description
    return label
  }()
  
  let icon: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
    imageView.layer.cornerRadius = Constants.iconSize / 2
    imageView.layer.masksToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  let horizontalStack: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 16
    return stackView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with model: CurrencySelectionCellModel) {
    currencyName.text = model.currencyName
    currencyCode.text = model.currencyCode
    icon.image = model.icon
    model.isSelectable ? enable() : disable()
  }
  
  private func enable() {
    setItemsAlpha(newAlpha: 1.0)
    selectionStyle = .default
  }
  
  private func disable() {
    setItemsAlpha(newAlpha: 0.5)
    selectionStyle = .none
  }
  
  private func setItemsAlpha(newAlpha: CGFloat) {
    icon.alpha = newAlpha
    currencyCode.alpha = newAlpha
    currencyName.alpha = newAlpha
  }
  
  private func setupView() {
    horizontalStack.translatesAutoresizingMaskIntoConstraints = false
    horizontalStack.addArrangedSubview(icon)
    horizontalStack.addArrangedSubview(currencyCode)
    horizontalStack.addArrangedSubview(currencyName)
    horizontalStack.addArrangedSubview(.horizontalSpacer)
    addSubview(horizontalStack)
    horizontalStack.pinEdges(to: self, offsets: UIEdgeInsets(top: Constants.margin, left: Constants.margin, bottom: -Constants.margin, right: -Constants.margin))
  }
}
