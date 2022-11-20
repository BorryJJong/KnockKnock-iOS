//
//  UITableHeaderFooterView+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/18.
//

import UIKit

extension UITableViewHeaderFooterView {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}
