//
//  Created by Ireneusz Sołek
//  

import UIKit

class ConverterViewController: UIViewController {
  enum EditState {
    case editing
    case viewing
  }
  
  struct Constants {
    static let margin: CGFloat = 16
  }

  var viewModel: ConverterViewModel
  var cellsDataCache: [ExchangeRateCellModel] = []
  
  var editState: EditState = .viewing {
    didSet {
      addCurrencyView.state = (editState == .editing) ? .disabled : .enabled
    }
  }
  private let cellModelMapper: ExchangeRateCellModelMapper
  private let addCurrencyView = AddCurrencyPairView()
  private let colorProvider = ColorProvider()
  lazy var tableView = viewComponentsFactory.tableView
  private lazy var viewComponentsFactory: ViewComponentsFactory = ViewComponentsFactory(userInterfaceStyle: traitCollection.userInterfaceStyle)
  private lazy var editButton: UIButton = {
    let button = viewComponentsFactory.editButton
    button.setTitle(editState.buttonTitle, for: .normal)
    return button
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
}

//MARK: setup
private extension ConverterViewController {
  func setupView() {
    let contentView = viewComponentsFactory.makeMainView(with: addCurrencyView)
    view.addSubview(contentView)
    contentView.pinToSafeArea(of: view)
  }
  
  func setup() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(ExchangeRateCell.self, forCellReuseIdentifier: "exchangeRate")
    addCurrencyView.addCurrencyPairButton.addTarget(self, action: #selector(addCurrencyPairButtonTapped), for: .touchUpInside)
    editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    bindViewModel()
    viewModel.startLoading()
  }
  
  func bindViewModel() {
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
}

//MARK: buttons actions
extension ConverterViewController {
  @objc func addCurrencyPairButtonTapped() {
    viewModel.addCurrencyPair()
  }
  
  @objc func editButtonTapped() {
    editState = editState.toggle()
    viewModel.viewDidChangeDataProcessingCapability(canProcessData: editState != .editing)
    editButton.setTitle(editState.buttonTitle, for: .normal)
    tableView.setEditing(editState == .editing, animated: true)
  }
}

//MARK: activity indicator
extension ConverterViewController {
  private func showActivityIndicator() {
    self.view.addSubview(viewComponentsFactory.activityIndicator)
    viewComponentsFactory.activityIndicator.center = self.view.center
    viewComponentsFactory.activityIndicator.startAnimating()
  }
  
  private func hideAcivityIndicator() {
    viewComponentsFactory.activityIndicator.stopAnimating()
  }
}
