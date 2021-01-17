//
//  Created by Ireneusz Sołek
//  

import UIKit

extension UIView {
  func pinEdges(to other: UIView, offsets: UIEdgeInsets = .zero, edges: UIRectEdge = .all) {
    self.translatesAutoresizingMaskIntoConstraints = false
    if edges.contains(.left) || edges.contains(.all) {
      let leading = leadingAnchor.constraint(equalTo: other.leadingAnchor)
      leading.constant = offsets.left
      leading.isActive = true
    }
    if edges.contains(.right) || edges.contains(.all) {
      let trailing = trailingAnchor.constraint(equalTo: other.trailingAnchor)
      trailing.constant = offsets.right
      trailing.isActive = true
    }
    if edges.contains(.top) || edges.contains(.all) {
      let top = topAnchor.constraint(equalTo: other.topAnchor)
      top.constant = offsets.top
      top.isActive = true
    }
    if edges.contains(.bottom) || edges.contains(.all) {
      let bottom = bottomAnchor.constraint(equalTo: other.bottomAnchor)
      bottom.constant = offsets.bottom
      bottom.isActive = true
    }
  }
  
  func pinToSafeArea(of other: UIView, offsets: UIEdgeInsets = .zero, edges: UIRectEdge = .all) {
    self.translatesAutoresizingMaskIntoConstraints = false
    if edges.contains(.left) || edges.contains(.all) {
      let constraint = leadingAnchor.constraint(equalTo: other.safeAreaLayoutGuide.leadingAnchor)
      constraint.constant = offsets.left
      constraint.isActive = true
    }
    if edges.contains(.right) || edges.contains(.all) {
      let constraint = trailingAnchor.constraint(equalTo: other.safeAreaLayoutGuide.trailingAnchor)
      constraint.constant = offsets.right
      constraint.isActive = true
    }
    if edges.contains(.top) || edges.contains(.all) {
      let constraint = topAnchor.constraint(equalTo: other.safeAreaLayoutGuide.topAnchor)
      constraint.constant = offsets.top
      constraint.isActive = true
    }
    if edges.contains(.bottom) || edges.contains(.all) {
      let constraint = bottomAnchor.constraint(equalTo: other.safeAreaLayoutGuide.bottomAnchor)
      constraint.constant = offsets.bottom
      constraint.isActive = true
    }
  }
}
