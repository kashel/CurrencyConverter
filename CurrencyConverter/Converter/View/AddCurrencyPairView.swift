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
    static let iconMarginRight: CGFloat = 16
    static let iconMarginLeft: CGFloat = 0
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
    button.titleLabel?.font = fontProvider.button
    button.setTitleColor(colorProvider.link, for: .normal)
    button.setTitleColor(colorProvider.inactiveLink, for: .highlighted)
    button.setTitleColor(colorProvider.inactiveLink, for: .disabled)
    button.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)

    return button
  }()
  
  override func willMove(toSuperview newSuperview: UIView?) {
    setupView()
  }
  
  private func setupView() {
    addCurrencyPairButton.translatesAutoresizingMaskIntoConstraints = false
    addCurrencyPairButton.imageView?.widthAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
    addCurrencyPairButton.imageView?.heightAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
    addCurrencyPairButton.heightAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
    addCurrencyPairButton.imageEdgeInsets.right = Constants.iconMarginRight
    addCurrencyPairButton.imageEdgeInsets.left = Constants.iconMarginLeft
    addCurrencyPairButton.imageView!.contentMode = .scaleAspectFit
    self.addSubview(addCurrencyPairButton)
    addCurrencyPairButton.pinEdges(to: self)
  }
}
