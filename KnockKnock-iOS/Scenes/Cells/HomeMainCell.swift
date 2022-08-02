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

class HomeMainCell: BaseCollectionViewCell {

  // MARK: - UIs

  let mainImageView = UIImageView().then {
    $0.image = UIImage(named: "feed_sample_1")
    $0.contentMode = .scaleToFill
  }

  let topGradientImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_bg_gradient_top_bk
  }

  let bottomGradientImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_bg_gradient_bottom_bk
  }

  override func setupConstraints() {
    [self.mainImageView, self.topGradientImageView, self.bottomGradientImageView].addSubViews(self.contentView)

    self.mainImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    self.topGradientImageView.snp.makeConstraints {
      $0.edges.top.trailing.leading.equalToSuperview()
      $0.height.equalTo(300)
    }

    self.bottomGradientImageView.snp.makeConstraints {
      $0.edges.bottom.trailing.leading.equalToSuperview()
    }
  }
}
