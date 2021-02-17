//
//  Created by Ireneusz Sołek
//  

import UIKit

class CurrencySelectionViewController: UIViewController {
  struct Constants {
    static let cellReuseIdentifier = "selectCurrency"
  }
  var viewModel: CurrencySelectionViewModel
  private let colorProvider = ColorProvider()
  
  let tableView: UITableView = {
    let table = UITableView()
    table.separatorStyle = .none
    return table
  }()
  
  private lazy var cancelButton: UIBarButtonItem = {
    let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancellButtonTapped))
    return button
  }()
  
  init(viewModel: CurrencySelectionViewModel) {
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

//MARK: - setup
private extension CurrencySelectionViewController {
  private func setupView() {
    view.backgroundColor = colorProvider.background
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    tableView.pinToSafeArea(of: view)
    navigationItem.title = viewModel.title
    navigationItem.rightBarButtonItem = cancelButton
  }
  
  private func setup() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(CurrencySelectionCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
  }
}

//MARK: - button actions
extension CurrencySelectionViewController {
  @objc func cancellButtonTapped() {
    viewModel.cancelAction()
  }
}
