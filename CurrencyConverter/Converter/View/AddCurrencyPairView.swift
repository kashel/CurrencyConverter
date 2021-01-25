//
//  Created by Ireneusz Sołek
//  

import UIKit

class AddCurrencyPairView: UIView {
  enum State {
    case enabled
    case disabled
  }
  struct Constants {
    static let iconSize: CGFloat = 40
    static let iconMarginRight: CGFloat = 10
    static let iconMarginLeft: CGFloat = 0
    static let topMargin: CGFloat = 32
    static let margin: CGFloat = 16
  }
  let fontProvider = FontProvider()
  let colorProvider = ColorProvider()
  var state: State? {
    didSet {
      addCurrencyPairButton.isEnabled = state == .enabled
    }
  }
  
  lazy var addCurrencyPairButton: UIButton = {
    let button = UIButton()
    button.setTitle("Add currency pair", for: .normal)
    button.titleLabel?.font = fontProvider.title
    button.setTitleColor(colorProvider.link, for: .normal)
    button.setTitleColor(colorProvider.inactiveLink, for: .highlighted)
    button.setTitleColor(colorProvider.inactiveLink, for: .disabled)
    button.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)

    return button
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
    addCurrencyPairButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
    addCurrencyPairButton.imageView?.widthAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
    addCurrencyPairButton.imageView?.heightAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
    addCurrencyPairButton.translatesAutoresizingMaskIntoConstraints = false
    addCurrencyPairButton.heightAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
    addCurrencyPairButton.imageEdgeInsets.right = Constants.iconMarginRight
    addCurrencyPairButton.imageEdgeInsets.left = Constants.iconMarginLeft
    addCurrencyPairButton.imageView!.contentMode = .scaleAspectFit
    horizontalStackView.addArrangedSubview(addCurrencyPairButton)
    horizontalStackView.addArrangedSubview(.horizontalSpacer)
    addSubview(horizontalStackView)
    horizontalStackView.pinEdges(to: self)
  }
}
