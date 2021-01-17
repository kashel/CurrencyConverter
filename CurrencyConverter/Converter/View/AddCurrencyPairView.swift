//
//  Created by Ireneusz Sołek
//  

import UIKit

class AddCurrencyPairView: UIView {
  let addCurrencyPairButton: UIButton = {
    let button = UIButton()
    button.setTitle("Add currency pair", for: .normal)
    return button
  }()
  
  override func willMove(toSuperview newSuperview: UIView?) {
    setupView()
  }
  
  private func setupView() {
    addCurrencyPairButton.center(with: self)
    addSubview(addCurrencyPairButton)
  }
}
