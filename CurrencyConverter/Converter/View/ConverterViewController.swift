//
//  Created by Ireneusz Sołek
//  

import UIKit

class ConverterViewController: UIViewController {
  struct Constants {
    static let margin: CGFloat = 16
  }
  private let colorProvider = ColorProvider()
  private let tableView: UITableView = {
    let table = UITableView()
    table.separatorStyle = .none
    table.allowsSelection = false
    return table
  }()
  private let addCurrencyView = AddCurrencyPairView()
  private var viewModel: ConverterViewModel
  private let cellModelMapper: ExchangeRateCellModelMapper
  private var cellsDataCache: [ExchangeRateCellModel] = []
  
  lazy var verticalStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = Constants.margin
    return stack
  }()
  
  lazy var activityIndicator: UIActivityIndicatorView = {
    let style: UIActivityIndicatorView.Style = traitCollection.userInterfaceStyle == .dark ? .white : .gray
    let activityIndicator = UIActivityIndicatorView(style: style)
    activityIndicator.hidesWhenStopped = true
    return activityIndicator
  }()
  
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
    verticalStackView.addArrangedSubview(addCurrencyView)
    verticalStackView.addArrangedSubview(tableView)
    view.addSubview(verticalStackView)
    verticalStackView.pinToSafeArea(of: view)
  }
  
  private func setup() {
    tableView.dataSource = self
    tableView.register(ExchangeRateCell.self, forCellReuseIdentifier: "exchangeRate")
    addCurrencyView.addCurrencyPairButton.addTarget(self, action: #selector(addCurrencyPairButtonTapped), for: .touchUpInside)
    bindViewModel()
    viewModel.startLoading()
  }
  
  private func bindViewModel() {
    viewModel.actions = { [weak self] viewModelAction in
      guard let self = self else {
        return
      }
      switch viewModelAction {
      case .initialDataLoaded(let exchangeRates):
        self.hideAcivityIndicator()
        self.cellsDataCache = exchangeRates.map{ exchangeRate in
          self.cellModelMapper.map(exchangeRate: exchangeRate)
        }
        self.tableView.reloadData()
      case .dataLoaded(let allRates, let isNewRateAdded):
        self.hideAcivityIndicator()
        self.tableView.beginUpdates()
        self.cellsDataCache = allRates.map{ exchangeRate in
          self.cellModelMapper.map(exchangeRate: exchangeRate)
        }
        if isNewRateAdded {
          self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
        if let indexPathsForVisibleRows = self.tableView.indexPathsForVisibleRows {
          let indexPaths = isNewRateAdded ? Array(indexPathsForVisibleRows.dropFirst()) : indexPathsForVisibleRows
          self.tableView.reloadRows(at: indexPaths, with: .none)
        }
        self.tableView.endUpdates()
      case .loading:
        self.showActivityIndicator()
      }
    }
  }
  
  @objc func addCurrencyPairButtonTapped() {
    viewModel.addCurrencyPair()
  }
  
  private func showActivityIndicator() {
    self.view.addSubview(self.activityIndicator)
    self.activityIndicator.center = self.view.center
    self.activityIndicator.startAnimating()
  }
  
  private func hideAcivityIndicator() {
    self.activityIndicator.stopAnimating()
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

