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
    viewComponentsFactory.plusButton.addTarget(self, action: #selector(ctaButtonTapped), for: .touchUpInside)
  }
  
  @objc func ctaButtonTapped() {
    viewModel.continueAction()
  }
}
