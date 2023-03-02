//
//  HomeMainCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/02.
//

import UIKit

import SnapKit
import Then
import KKDSKit

final class HomeMainCell: BaseCollectionViewCell {

  // MARK: - UIs

  private let mainImageView = UIImageView().then {
    $0.image = UIImage(named: "feed_sample_1")
    $0.contentMode = .scaleToFill
  }

  private let topGradientImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_bg_gradient_top_bk
  }

  private let bottomGradientImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_bg_gradient_bottom_bk
  }

  // MARK: - Bind

  func bind(image: String) {
    self.mainImageView.setImageFromStringUrl(
      stringUrl: image,
      defaultImage: UIImage()
    )
  }

  // MARK: - Constraints

  override func setupConstraints() {
    [self.mainImageView, self.topGradientImageView, self.bottomGradientImageView].addSubViews(self.contentView)

    self.mainImageView.snp.makeConstraints {
      $0.edges.equalTo(self.contentView)
    }

    self.topGradientImageView.snp.makeConstraints {
      $0.top.trailing.leading.equalTo(self.contentView)
    }

    self.bottomGradientImageView.snp.makeConstraints {
      $0.bottom.trailing.leading.equalTo(self.contentView)
    }
  }
}
