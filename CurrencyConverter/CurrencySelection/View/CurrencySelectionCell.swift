//
//  Created by Ireneusz Sołek
//  

import UIKit

struct CurrencySelectionCellModel {
  let currencyName: String
  let isSelectable: Bool
}

class CurrencySelectionCell: UITableViewCell {
  let currencyName: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let verticalStack: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .leading
    return stackView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with model: CurrencySelectionCellModel) {
    currencyName.text = model.currencyName
    selectionStyle = model.isSelectable ? .default : .none
  }
  
  private func setupView() {
    verticalStack.translatesAutoresizingMaskIntoConstraints = false
    verticalStack.addArrangedSubview(currencyName)
    addSubview(verticalStack)
    verticalStack.pinEdges(to: self)
  }
}
