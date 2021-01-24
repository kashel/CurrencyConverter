//
//  Created by Ireneusz Sołek
//  

import UIKit

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
