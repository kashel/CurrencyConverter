//
//  Created by Ireneusz Sołek
//  

import UIKit

class DashboardViewConroller: UIViewController {
  let viewModel: DashboardViewModel
  
  lazy var button: UIButton = {
    let newButton = UIButton(type: .custom)
    newButton.setTitle(viewModel.ctaButtonTitle, for: .normal)
    newButton.setTitleColor(.blue, for: .normal)
    newButton.setTitleColor(.gray, for: .highlighted)
    return newButton
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
  
  private func setupView() {
    view.backgroundColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)
    button.center(with: view)
    button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
  private func setup() {
    button.addTarget(self, action: #selector(ctaButtonTapped), for: .touchUpInside)
  }
  
  @objc func ctaButtonTapped() {
    viewModel.continueAction()
  }
}
