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

class PopularPostCell: BaseCollectionViewCell {

  // MARK: - UIs

  let thumbnailImageView = UIImageView().then {
    $0.backgroundColor = .gray40
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }

  let gradientImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_bg_gradient_bottom_bk
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }

  let nickNameLabel = UILabel().then {
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
      $0.height.equalTo(100)
    }

    self.nickNameLabel.snp.makeConstraints {
      $0.leading.equalTo(self.thumbnailImageView.snp.leading).offset(10)
      $0.bottom.equalTo(self.thumbnailImageView.snp.bottom).offset(-10)
    }
  }
}
