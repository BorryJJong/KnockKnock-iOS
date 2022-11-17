//
//  BaseTableViewCell.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/06.
//

import UIKit

class BaseTableViewCell<T>: UITableViewCell {
  
  // MARK: - Initialize
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    self.setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var model: T? {
    didSet {
      if let model = model {
        bind(model)
      }
    }
  }

  func bind(_ model: T?) { }

  func setupConstraints() { /* override point */ }
}
