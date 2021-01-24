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
  private let colorProvider = ColorProvider()
  private let tableView: UITableView = {
    let table = UITableView()
    table.separatorStyle = .none
    table.allowsSelection = false
    return table
  }()
  private let addCurrencyView = AddCurrencyPairView()
  var viewModel: ConverterViewModel
  private let cellModelMapper: ExchangeRateCellModelMapper
  var cellsDataCache: [ExchangeRateCellModel] = []
  
  lazy var verticalStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = Constants.margin
    return stack
  }()
  
  lazy var horizontalStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    return stack
  }()
  
  lazy var activityIndicator: UIActivityIndicatorView = {
    let style: UIActivityIndicatorView.Style = traitCollection.userInterfaceStyle == .dark ? .white : .gray
    let activityIndicator = UIActivityIndicatorView(style: style)
    activityIndicator.hidesWhenStopped = true
    return activityIndicator
  }()
  
  lazy var editButton: UIButton = {
    let button = UIButton()
    button.setTitle(editState.buttonTitle, for: .normal)
    button.setTitleColor(colorProvider.link, for: .normal)
    button.setTitleColor(colorProvider.inactiveLink, for: .highlighted)
    return button
  }()
  
  var editState: EditState = .viewing {
    didSet {
      addCurrencyView.state = (editState == .editing) ? .disabled : .enabled
    }
  }
  
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
    horizontalStackView.addArrangedSubview(addCurrencyView)
    horizontalStackView.addArrangedSubview(.horizontalSpacer)
    horizontalStackView.addArrangedSubview(editButton)
    let wrapper = UIView()
    wrapper.addSubview(horizontalStackView)
    horizontalStackView.pinEdges(to: wrapper, offsets: UIEdgeInsets(top: Constants.margin, left: Constants.margin, bottom: -Constants.margin, right: -Constants.margin))
    verticalStackView.addArrangedSubview(wrapper)
    verticalStackView.addArrangedSubview(tableView)
    view.addSubview(verticalStackView)
    verticalStackView.pinToSafeArea(of: view)
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
    self.view.addSubview(self.activityIndicator)
    self.activityIndicator.center = self.view.center
    self.activityIndicator.startAnimating()
  }
  
  private func hideAcivityIndicator() {
    self.activityIndicator.stopAnimating()
  }
}
