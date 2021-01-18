//
//  Created by Ireneusz Sołek
//  

import UIKit

class CurrencySelectionViewController: UIViewController {
  var viewModel: CurrencySelectionViewModel
  
  private let colorProvider = ColorProvider()
  
  let tableView: UITableView = {
    let table = UITableView()
    table.separatorStyle = .none
    return table
  }()
  
  lazy var cancelButton: UIBarButtonItem = {
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
    tableView.register(CurrencySelectionCell.self, forCellReuseIdentifier: "selectCurrency")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CurrencySelectionViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.cellsData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectCurrency") as? CurrencySelectionCell else {
      return UITableViewCell()
    }
    cell.configure(with: viewModel.cellsData[indexPath.row])
    return cell
  }
}

extension CurrencySelectionViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return viewModel.cellsData[indexPath.row].isSelectable ? indexPath : nil
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.continueAction(selectedCurrency: viewModel.model[indexPath.row].currency)
  }
}

extension CurrencySelectionViewController {
  @objc func cancellButtonTapped() {
    viewModel.cancelAction()
  }
}
