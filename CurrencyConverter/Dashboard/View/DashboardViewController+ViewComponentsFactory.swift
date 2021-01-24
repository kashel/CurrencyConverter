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
      return newButton
    }()
    
    private lazy var verticalStackView: UIStackView = {
      let stack = UIStackView()
      stack.axis = .vertical
      stack.spacing = Constants.margin
      stack.alignment = .center
      return stack
    }()
    
    private lazy var icon: UIImageView = {
      let image = #imageLiteral(resourceName: "Plus")
      let imageView = UIImageView(image: image)
      imageView.widthAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
      imageView.heightAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
      return imageView
    }()
    
    private lazy var subtitle: UILabel = {
      let label = UILabel()
      label.text = L10n.chooseCurrencyPair
      label.font = fontProvider.subtitle
      label.textColor = colorProvider.description
      label.numberOfLines = 0
      return label
    }()
    
    func makeMainView() -> UIView {
      verticalStackView.addArrangedSubview(icon)
      verticalStackView.addArrangedSubview(button)
      verticalStackView.addArrangedSubview(subtitle)
      verticalStackView.translatesAutoresizingMaskIntoConstraints = false
      return verticalStackView
    }
  }
}
