//
//  BaseCollectionViewCell.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/04/17.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.setupConstraints()
    self.setupCollectionView()
    self.setupConfigure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupCollectionView() { }

  func setupConstraints() { /* override point */ }
  func setupConfigure() {/* override point */}
}
