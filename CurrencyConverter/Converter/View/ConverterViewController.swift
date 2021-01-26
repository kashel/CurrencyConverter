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
    static let cellReuseIdentifier = "exchangeRate"
  }

  var viewModel: ConverterViewModel
  var cellsDataCache: [ExchangeRateCellModel] = []
  
  var editState: EditState = .viewing {
    didSet {
      addCurrencyView.state = (editState == .editing) ? .disabled : .enabled
      editButton.isEnabled = (editState == .editing) || cellsDataCache.count > 0
      editButton.setTitle(editState.buttonTitle, for: .normal)
      tableView.setEditing(editState == .editing, animated: true)
    }
  }
  private let cellModelMapper: ExchangeRateCellModelMapper
  private let addCurrencyView = AddCurrencyPairView()
  private let colorProvider = ColorProvider()
  lazy var tableView = viewComponentsFactory.tableView
  private lazy var viewComponentsFactory: ViewComponentsFactory = ViewComponentsFactory(userInterfaceStyle: traitCollection.userInterfaceStyle)
  lazy var editButton: UIButton = {
    let button = viewComponentsFactory.editButton
    button.setTitle(editState.buttonTitle, for: .normal)
    return button
  }()
  
  
  init(viewModel: ConverterViewModel, cellModelMapper: ExchangeRateCellModelMapper) {
    self.viewModel = viewModel
    self.cellModelMapper = cellModelMapper
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
  }
}

//MARK: - setup
private extension ConverterViewController {
  func setupView() {
    self.view.backgroundColor = colorProvider.background
    self.title = "Rates & converter"
    let contentView = viewComponentsFactory.makeMainView(with: addCurrencyView)
    view.addSubview(contentView)
    contentView.pinToSafeArea(of: view)
  }
  
  func setup() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(ExchangeRateCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
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
        self.editState = .viewing
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
        self.editState = self.editState.toggle().toggle()
      case .loading:
        self.showActivityIndicator()
      case .allDataRemoved:
        self.editState = .viewing
      }
    }
  }
}

//MARK: - buttons actions
private extension ConverterViewController {
  @objc func addCurrencyPairButtonTapped() {
    viewModel.addCurrencyPair()
  }
  
  @objc func editButtonTapped() {
    editState = editState.toggle()
    viewModel.viewDidChangeDataProcessingCapability(canProcessData: editState != .editing)
  }
}

//MARK: - activity indicator
private extension ConverterViewController {
  private func showActivityIndicator() {
    self.view.addSubview(viewComponentsFactory.activityIndicator)
    viewComponentsFactory.activityIndicator.center = self.view.center
    viewComponentsFactory.activityIndicator.startAnimating()
  }
  
  private func hideAcivityIndicator() {
    viewComponentsFactory.activityIndicator.stopAnimating()
  }
}

//MARK: - application lifecycle events
private extension ConverterViewController {
  @objc func appMovedToBackground() {
    viewModel.viewDidChangeDataProcessingCapability(canProcessData: false)
  }
  @objc func appMovedToForeground() {
    viewModel.viewDidChangeDataProcessingCapability(canProcessData: true)
  }
}
