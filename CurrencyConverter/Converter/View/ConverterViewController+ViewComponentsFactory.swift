//
//  Created by Ireneusz Sołek
//  

import UIKit

extension ConverterViewController {
  struct ViewComponentsFactory {
    let userInterfaceStyle: UIUserInterfaceStyle
    
    init(userInterfaceStyle: UIUserInterfaceStyle) {
      self.userInterfaceStyle = userInterfaceStyle
    }
    
    private let colorProvider = ColorProvider()
    lazy var tableView: UITableView = {
      let table = UITableView()
      table.separatorStyle = .none
      table.allowsSelection = false
      return table
    }()
    
    lazy var verticalStackView: UIStackView = {
      let stack = UIStackView()
      stack.axis = .vertical
      stack.spacing = Constants.margin
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
      button.setTitleColor(colorProvider.link, for: .normal)
      button.setTitleColor(colorProvider.inactiveLink, for: .highlighted)
      return button
    }()
  }
}
