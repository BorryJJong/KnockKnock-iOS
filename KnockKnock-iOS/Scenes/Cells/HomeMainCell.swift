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

//  let gradientImageView = UIImageView().then {
//  }

  override func setupConstraints() {
    [self.mainImageView].addSubViews(self.contentView)

    self.mainImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
