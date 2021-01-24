//
//  Created by Ireneusz Sołek
//  

import UIKit

extension ConverterViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return editState == .editing
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      viewModel.viewDidDeleteCurrencyPairAt(index: indexPath.row)
      if editingStyle == .delete {
          cellsDataCache.remove(at: indexPath.row)
          tableView.deleteRows(at: [indexPath], with: .fade)
      }
  }
}
