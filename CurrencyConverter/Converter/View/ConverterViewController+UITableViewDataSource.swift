//
//  Created by Ireneusz Sołek
//  

import UIKit

extension ConverterViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellsDataCache.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier) as? ExchangeRateCell else {
      return UITableViewCell()
    }
    cell.configure(with: cellsDataCache[indexPath.row])
    return cell
  }
}
