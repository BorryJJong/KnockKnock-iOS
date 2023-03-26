//
//  TapCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/12.
//

import UIKit

import KKDSKit

final class TapCell: BaseCollectionViewCell {

  // MARK: - UIs

  let tapLabel = UILabel().then {
    $0.text = "진행 이벤트"
    $0.font = .systemFont(ofSize: 15)
    $0.textColor = .black
  }

  // MARK: - Bind

  func bind(tapName: String, isSelected: Bool) {
    self.tapLabel.do {
      $0.text = tapName
      if isSelected {
        $0.textColor = KKDS.Color.green40
        $0.font = .systemFont(ofSize: 15, weight: .bold)
      } else {
        $0.textColor = KKDS.Color.gray70
        $0.font = .systemFont(ofSize: 15, weight: .light)
      }
    }
  }

  // MARK: - Configure

  override func setupConfigure() {
    [self.tapLabel].addSubViews(self.contentView)

    self.tapLabel.snp.makeConstraints {
      $0.centerX.equalTo(self.contentView.snp.centerX)
      $0.bottom.equalTo(self.contentView.snp.bottom)
    }
  }
}
