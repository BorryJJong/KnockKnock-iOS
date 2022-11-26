//
//  BaseTableViewHeaderFooterView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/18.
//

import UIKit

class BaseTableViewHeaderFooterView<T>: UITableViewHeaderFooterView {

  var model: T? {
    didSet {
      if let model = model {
        bind(model)
      }
    }
  }

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)

    self.setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func bind(_ model: T?) { /* override point */ }

  func setupConstraints() { /* override point */ }

}
