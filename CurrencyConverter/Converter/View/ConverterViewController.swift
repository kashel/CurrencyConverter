//
//  Created by Ireneusz Sołek
//  

import UIKit

class ConverterViewController: UIViewController {
  private let colorProvider = ColorProvider()
  private let tableView = UITableView()
  private var viewModel: ConverterViewModel
  private let cellModelMapper: ExchangeRateCellModelMapper
  private var cellsDataCache: [ExchangeRateCellModel] = []
  
  init(viewModel: ConverterViewModel, cellModelMapper: ExchangeRateCellModelMapper) {
    self.viewModel = viewModel
    self.cellModelMapper = cellModelMapper
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = colorProvider.background
    self.title = "Rates & converter"
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  private func setupView() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    tableView.pinToSafeArea(of: view)
  }
  
  private func setup() {
    tableView.dataSource = self
    tableView.register(ExchangeRateCell.self, forCellReuseIdentifier: "exchangeRate")
    bindViewModel()
    viewModel.startLoading()
  }
  
  private func bindViewModel() {
    viewModel.actions = { [weak self] viewModelAction in
      switch viewModelAction {
      case .dataLoaded(let rates):
        self?.cellsDataCache = rates.compactMap{ [weak self] exchangeRate in
          guard let self = self else { return nil }
          return self.cellModelMapper.map(exchangeRate: exchangeRate)
        }
        self?.tableView.reloadData()
      }
    }
  }
}

extension ConverterViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellsDataCache.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "exchangeRate") as? ExchangeRateCell else {
      return UITableViewCell()
    }
    cell.configure(with: cellsDataCache[indexPath.row])
    return cell
  }
}

