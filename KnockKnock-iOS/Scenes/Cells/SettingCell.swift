//
//  SettingCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/05.
//

import UIKit

import SnapKit
import KKDSKit
import Then

final class SettingCell: BaseCollectionViewCell {

  // MARK: - UI

  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 15, weight: .bold)
    $0.text = "프로필 수정"
    $0.textColor = .black
  }

  private let enterButton = UIButton().then {
    $0.setImage(KKDS.Image.ic_left_10_gr, for: .normal)
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.titleLabel, self.enterButton].addSubViews(self.contentView)

    self.titleLabel.snp.makeConstraints {
      $0.centerY.leading.equalToSuperview()
    }

    self.enterButton.snp.makeConstraints {
      $0.trailing.equalToSuperview()
      $0.centerY.equalTo(self.titleLabel)
    }
  }
}
