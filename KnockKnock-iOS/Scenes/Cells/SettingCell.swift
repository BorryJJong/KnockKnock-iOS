//
//  SettingCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/05.
//

import UIKit

final class SettingCell: UICollectionViewListCell {
  // MARK: - Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
