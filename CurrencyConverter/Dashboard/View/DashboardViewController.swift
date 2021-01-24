//
//  Created by Ireneusz Sołek
//  

import UIKit

class DashboardViewConroller: UIViewController {
  struct Constants {
    static let margin: CGFloat = 16
    static let iconSize: CGFloat = 60
  }
  
  private let viewModel: DashboardViewModel
  private let fontProvider = FontProvider()
  private let colorProvider = ColorProvider()
  
  private lazy var button: UIButton = {
    let newButton = UIButton(type: .custom)
    newButton.titleLabel?.font = fontProvider.title
    newButton.setTitle(viewModel.ctaButtonTitle, for: .normal)
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
    label.text = "Choose a currency pair to compare their live rates"
    label.font = fontProvider.subtitle
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
    view.backgroundColor = colorProvider.background
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
