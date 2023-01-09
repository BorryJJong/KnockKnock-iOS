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

final class LikeDetailCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let profileImageViewWidth = 45.f

    static let likeImageViewWidth = 16.f

    static let userNameLabelBottomMargin = -2.5.f
    static let userNameLabelLeadingMargin = 15.f

    static let likeLabelTopMargin = 5.f
    static let likeLabelLeadingMargin = 15.f
  }

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

  // MARK: - Bind

  func bind(like: Like.Info) {
    if let image = like.userImage {
      self.profileImageView.image = UIImage(named: image)
    } else {
      self.profileImageView.image = KKDS.Image.ic_person_24
    }
      self.userNameLabel.text = like.userName
  }

  // MARK: - Constraints

  override func setupConstraints() {
    [self.profileImageView, self.likeImageView, self.userNameLabel, self.likeLabel].addSubViews(self.contentView)

    self.profileImageView.snp.makeConstraints {
      $0.top.bottom.leading.equalTo(self.contentView)
      $0.width.height.equalTo(Metric.profileImageViewWidth)
    }

    self.likeImageView.snp.makeConstraints {
      $0.bottom.trailing.equalTo(self.profileImageView)
      $0.width.height.equalTo(Metric.likeImageViewWidth)
    }

    self.userNameLabel.snp.makeConstraints {
      $0.bottom.equalTo(self.profileImageView.snp.centerY).offset(Metric.userNameLabelBottomMargin)
      $0.leading.equalTo(self.profileImageView.snp.trailing).offset(Metric.userNameLabelLeadingMargin)
    }

    self.likeLabel.snp.makeConstraints {
      $0.top.equalTo(self.userNameLabel.snp.bottom).offset(Metric.likeLabelTopMargin)
      $0.leading.equalTo(self.profileImageView.snp.trailing).offset(Metric.likeLabelLeadingMargin)
    }
  }
}
