//
//  PopularPostCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/05.
//

import UIKit

import SnapKit
import Then
import KKDSKit

final class PopularPostCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let gradientImageViewHeight = 100.f
    static let nickNameLabelLeadingMargin = 10.f
    static let nickNameLabelBottomMargin = -10.f
  }

  // MARK: - UIs

  private let thumbnailImageView = UIImageView().then {
    $0.backgroundColor = .gray40
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }

  private let gradientImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_bg_gradient_bottom_bk
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }

  private let nickNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = .white
    $0.text = "@ksungmin94"
  }

  // MARK: - Constraints

  override func setupConstraints() {
    [self.thumbnailImageView, self.gradientImageView, self.nickNameLabel].addSubViews(self.contentView)

    self.thumbnailImageView.snp.makeConstraints {
      $0.edges.equalTo(self.contentView)
    }

    self.gradientImageView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalTo(self.thumbnailImageView)
      $0.height.equalTo(Metric.gradientImageViewHeight)
    }

    self.nickNameLabel.snp.makeConstraints {
      $0.leading.equalTo(self.thumbnailImageView.snp.leading).offset(Metric.nickNameLabelLeadingMargin)
      $0.bottom.equalTo(self.thumbnailImageView.snp.bottom).offset(Metric.nickNameLabelBottomMargin)
    }
  }
}
