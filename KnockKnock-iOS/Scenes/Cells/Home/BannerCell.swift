//
//  bannerCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/04.
//

import Foundation
import UIKit

final class BannerCell: BaseCollectionViewCell {

  // MARK: - UIs

  private let bannerImageView = UIImageView().then {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 5
  }

  // MARK: - Bind

  func bind(banner: HomeBanner) {
    bannerImageView.setImageFromStringUrl(
      stringUrl: banner.image,
      defaultImage: UIImage()
    )
  }

  // MARK: - Constraints

  override func setupConstraints() {
    [self.bannerImageView].addSubViews(self.contentView)

    self.bannerImageView.snp.makeConstraints {
      $0.edges.equalTo(self.contentView)
    }
  }
}
