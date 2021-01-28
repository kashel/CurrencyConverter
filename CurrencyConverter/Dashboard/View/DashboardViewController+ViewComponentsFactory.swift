//
//  Created by Ireneusz Sołek
//  

import UIKit

extension DashboardViewConroller {
  class ViewComponentsFactory {
    private let fontProvider = FontProvider()
    private let colorProvider = ColorProvider()
    
    lazy var button: UIButton = {
      let newButton = UIButton(type: .custom)
      newButton.titleLabel?.font = fontProvider.title
      newButton.setTitleColor(colorProvider.link, for: .normal)
      newButton.setTitleColor(colorProvider.inactiveLink, for: .highlighted)
      newButton.accessibilityIdentifier = AccessibilityIdentifier.Dashboard.addCurrencyPairButton
      return newButton
    }()
    
    private lazy var verticalStackView: UIStackView = {
      let stack = UIStackView()
      stack.axis = .vertical
      stack.spacing = Constants.margin
      stack.alignment = .center
      return stack
    }()
    
    lazy var plusButton: UIButton = {
      let button = UIButton()
      button.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
      button.widthAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
      button.heightAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
      button.accessibilityIdentifier = AccessibilityIdentifier.Dashboard.addCurrencyPairIconButton
      button.accessibilityLabel = L10n.addCurrencyPair
      return button
    }()
    
    private lazy var subtitle: UILabel = {
      let label = UILabel()
      label.text = L10n.chooseCurrencyPair
      label.font = fontProvider.subtitle
      label.textColor = colorProvider.description
      label.numberOfLines = 0
      label.accessibilityIdentifier = AccessibilityIdentifier.Dashboard.chooseCurrencyPairDescription
      return label
    }()
    
    func makeMainView() -> UIView {
      verticalStackView.addArrangedSubview(plusButton)
      verticalStackView.addArrangedSubview(button)
      verticalStackView.addArrangedSubview(subtitle)
      verticalStackView.translatesAutoresizingMaskIntoConstraints = false
      return verticalStackView
    }
  }
}
