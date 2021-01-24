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
  private let colorProvider = ColorProvider()
  private let viewComponentsFactory = ViewComponentsFactory()
  private lazy var ctaButton: UIButton = {
    let button = viewComponentsFactory.button
    button.setTitle(viewModel.ctaButtonTitle, for: .normal)
    return button
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
    let contentView = viewComponentsFactory.makeMainView()
    view.addSubview(contentView)
    contentView.pinMaximalToSafeArea(of: view, offsets: UIEdgeInsets(top: Constants.margin, left: Constants.margin, bottom: -Constants.margin, right: -Constants.margin))
    ctaButton.center(with: view)
  }
  
  func setup() {
    ctaButton.addTarget(self, action: #selector(ctaButtonTapped), for: .touchUpInside)
  }
  
  @objc func ctaButtonTapped() {
    viewModel.continueAction()
  }
}

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
      label.text = "Choose a currency pair to compare their live rates"
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
