//
//  Created by Ireneusz Sołek
//  

import UIKit

extension ConverterViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    editState == .editing
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    setRefreshDeleteButtonState(enabled: (tableView.indexPathsForSelectedRows?.count ?? 0) > 0)
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    setRefreshDeleteButtonState(enabled: (tableView.indexPathsForSelectedRows?.count ?? 0) > 0)
  }
}
