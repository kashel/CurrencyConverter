//
//  Created by Ireneusz Sołek
//  

import UIKit

class AddCurrencyPairView: UIView {
  struct Constants {
    static let iconSize: CGFloat = 40
    static let topMargin: CGFloat = 32
    static let margin: CGFloat = 16
  }
  let fontProvider = FontProvider()
  let colorProvider = ColorProvider()
  
  lazy var addCurrencyPairButton: UIButton = {
    let button = UIButton()
    button.setTitle("Add currency pair", for: .normal)
    button.titleLabel?.font = fontProvider.title
    button.setTitleColor(colorProvider.link, for: .normal)
    button.setTitleColor(colorProvider.description, for: .highlighted)
    return button
  }()
  
  lazy var icon: UIImageView = {
    let image = #imageLiteral(resourceName: "Plus")
    let imageView = UIImageView(image: image)
    imageView.widthAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
    return imageView
  }()
  
  lazy var horizontalStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.spacing = Constants.margin
    stack.alignment = .leading
    return stack
  }()
  
  override func willMove(toSuperview newSuperview: UIView?) {
    setupView()
  }
  
  private func setupView() {
    horizontalStackView.addArrangedSubview(icon)
    horizontalStackView.addArrangedSubview(addCurrencyPairButton)
    horizontalStackView.addArrangedSubview(.horizontalSpacer)
    addSubview(horizontalStackView)
    horizontalStackView.pinEdges(to: self, offsets: UIEdgeInsets(top: Constants.topMargin, left: Constants.margin, bottom: -Constants.margin, right: -Constants.margin))
  }
}
