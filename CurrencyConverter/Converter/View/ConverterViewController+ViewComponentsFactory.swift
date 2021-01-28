//
//  Created by Ireneusz Sołek
//  

import UIKit

extension ConverterViewController {
  class ViewComponentsFactory {
    let userInterfaceStyle: UIUserInterfaceStyle
    
    init(userInterfaceStyle: UIUserInterfaceStyle) {
      self.userInterfaceStyle = userInterfaceStyle
    }
    
    private let colorProvider = ColorProvider()
    private let fontProvider = FontProvider()
    
    lazy var tableView: UITableView = {
      let table = UITableView()
      table.separatorStyle = .none
      table.allowsSelection = false
      table.allowsMultipleSelectionDuringEditing = true
      return table
    }()
    
    lazy var verticalStackView: UIStackView = {
      let stack = UIStackView()
      stack.axis = .vertical
      return stack
    }()
    
    lazy var horizontalStackView: UIStackView = {
      let stack = UIStackView()
      stack.axis = .horizontal
      return stack
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
      let style: UIActivityIndicatorView.Style = userInterfaceStyle == .dark ? .white : .gray
      let activityIndicator = UIActivityIndicatorView(style: style)
      activityIndicator.hidesWhenStopped = true
      return activityIndicator
    }()
    
    lazy var editButton: UIButton = {
      let button = UIButton()
      button.titleLabel?.font = fontProvider.button
      button.setTitleColor(colorProvider.link, for: .normal)
      button.setTitleColor(colorProvider.inactiveLink, for: .highlighted)
      button.setTitleColor(colorProvider.inactiveLink, for: .disabled)
      button.accessibilityIdentifier = AccessibilityIdentifier.Converter.editButton
      return button
    }()
    
    lazy var deleteButton: UIButton = {
      let button = UIButton()
      button.backgroundColor = .red
      button.titleLabel?.font = fontProvider.button
      button.setTitleColor(.white, for: .normal)
      button.setTitleColor(.gray, for: .highlighted)
      button.setTitle(L10n.delete, for: .normal)
      button.alpha = Constants.deleteButtonDisabledAlpha
      button.accessibilityIdentifier = AccessibilityIdentifier.Converter.deleteButton
      button.accessibilityLabel = L10n.delete
      return button
    }()
    
    lazy var deleteButtonView: UIView = {
      let view = UIStackView()
      view.addSubview(deleteButton)
      deleteButton.pinEdges(to: view, offsets: Constants.deleteButtonOffset)
      deleteButton.heightAnchor.constraint(equalToConstant: Constants.deleteButtonHeight).isActive = true
      deleteButton.layer.cornerRadius = Constants.deleteButtonCornerRadius
      deleteButton.clipsToBounds = true
      return view
    }()
    
    func makeMainView(with addCurrencyView: UIView) -> UIView {
      horizontalStackView.addArrangedSubview(addCurrencyView)
      horizontalStackView.addArrangedSubview(.horizontalSpacer)
      horizontalStackView.addArrangedSubview(editButton)
      let header = addDefaultMargins(to: horizontalStackView)
      verticalStackView.addArrangedSubview(header)
      verticalStackView.addArrangedSubview(tableView)
      return verticalStackView
    }
    
    private func addDefaultMargins(to contentView: UIView) -> UIView {
      let wrapper = UIView()
      wrapper.addSubview(contentView)
      contentView.pinEdges(to: wrapper, offsets: UIEdgeInsets(top: Constants.margin, left: Constants.margin, bottom: -Constants.margin, right: -Constants.margin))
      return wrapper
    }
  }
}
