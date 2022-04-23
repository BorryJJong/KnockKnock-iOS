//
//  BaseCollectionViewCell.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/04/17.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Initializing
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .black
    self.setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupConstraints() { /* override point */ }
}
