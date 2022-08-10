//
//  LikeDetailCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/06.
//

import UIKit

import SnapKit
import Then
import KKDSKit

class LikeDetailCell: BaseCollectionViewCell {

  // MARK: - UIs

  private let profileImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_person_24
  }

  private let likeImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_like_circle_16
  }

  private let userNameLabel = UILabel().then {
    $0.text = "ksungmin94"
    $0.font = .systemFont(ofSize: 15, weight: .semibold)
    $0.textColor = .black
  }

  private let likeLabel = UILabel().then {
    $0.text = "좋아요"
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = .gray60
  }

  // MARK: - Constraints

  override func setupConstraints() {
    [self.profileImageView, self.likeImageView, self.userNameLabel, self.likeLabel].addSubViews(self.contentView)

    self.profileImageView.snp.makeConstraints {
      $0.top.bottom.leading.equalTo(self.contentView)
      $0.width.height.equalTo(45)
    }

    self.likeImageView.snp.makeConstraints {
      $0.bottom.trailing.equalTo(self.profileImageView)
      $0.width.height.equalTo(16)
    }

    self.userNameLabel.snp.makeConstraints {
      $0.bottom.equalTo(self.profileImageView.snp.centerY)
      $0.leading.equalTo(self.profileImageView.snp.trailing).offset(15)
    }

    self.likeLabel.snp.makeConstraints {
      $0.top.equalTo(self.userNameLabel.snp.bottom)
      $0.leading.equalTo(self.profileImageView.snp.trailing).offset(15)
    }
  }
}
