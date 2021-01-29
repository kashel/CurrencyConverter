//
//  Created by Ireneusz Sołek
//  

import UIKit

extension CurrencySelectionViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    viewModel.cellsData[indexPath.row].isSelectable ? indexPath : nil
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.continueAction(selectedCurrency: viewModel.model[indexPath.row].currency)
  }
}
