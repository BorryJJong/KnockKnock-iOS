//
//  UITableView+Ext.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/06.
//

import UIKit

extension UITableView {
  
  func registCell(type: UITableViewCell.Type, identifier: String? = nil) {
    let cellID = identifier ?? type.identifier
    register(type, forCellReuseIdentifier: cellID)
  }

  func registCells(_ types: [UITableViewCell.Type]) {
    types.forEach { self.registCell(type: $0) }
  }
  
  func dequeueCell<Cell: UITableViewCell>(withType type: Cell.Type) -> Cell {
    return dequeueReusableCell(withIdentifier: type.identifier) as! Cell
  }
  
  func dequeueCell<Cell: UITableViewCell>(withType type: Cell.Type, for indexPath: IndexPath) -> Cell {
    return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as! Cell
  }
}
