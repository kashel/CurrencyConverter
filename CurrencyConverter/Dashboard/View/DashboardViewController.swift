//
//  Created by Ireneusz Sołek
//  

import UIKit

class DashboardViewConroller: UIViewController {
  struct Constants {
    static let mainButtonSize: CGFloat = 20
    static let margin: CGFloat = 16
    static let iconSize: CGFloat = 60
  }
  
  let viewModel: DashboardViewModel
  let fontProvider = FontProvider()
  let colorProvider = ColorProvider()
  
  lazy var button: UIButton = {
    let newButton = UIButton(type: .custom)
    newButton.titleLabel?.font = fontProvider.title
    newButton.titleLabel?.font = newButton.titleLabel?.font.withSize(Constants.mainButtonSize)
    newButton.setTitle(viewModel.ctaButtonTitle, for: .normal)
    newButton.setTitleColor(colorProvider.link, for: .normal)
    newButton.setTitleColor(colorProvider.description, for: .highlighted)
    return newButton
  }()
  
  lazy var verticalStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 16
    stack.alignment = .center
    return stack
  }()
  
  lazy var icon: UIImageView = {
    let image = #imageLiteral(resourceName: "Plus")
    let imageView = UIImageView(image: image)
    imageView.widthAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
    return imageView
  }()
  
  lazy var subtitle: UILabel = {
    let label = UILabel()
    label.text = "Choose a currency pair to compare their live rates"
    label.font = fontProvider.title
    label.textColor = colorProvider.description
    label.numberOfLines = 0
    return label
  }()
  
  init(viewModel: DashboardViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension DashboardViewConroller {
  func setupView() {
    view.backgroundColor = .white
    verticalStackView.addArrangedSubview(icon)
    verticalStackView.addArrangedSubview(button)
    verticalStackView.addArrangedSubview(subtitle)
    verticalStackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(verticalStackView)
    NSLayoutConstraint.activate([
      verticalStackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.margin),
      verticalStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.margin),
      verticalStackView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.margin),
      verticalStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.margin),
    ])
    button.center(with: view)
  }
  
  func setup() {
    button.addTarget(self, action: #selector(ctaButtonTapped), for: .touchUpInside)
  }
  
  @objc func ctaButtonTapped() {
    viewModel.continueAction()
  }
}
