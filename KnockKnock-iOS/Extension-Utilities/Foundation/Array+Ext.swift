//
//  Array+Ext.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/06.
//

import UIKit

extension Array where Element: UIView {
  func addSubViews(_ parentView: UIView) {
    self.forEach {
      parentView.addSubview($0)
    }
  }
}
