//
//  bannerCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/04.
//

import Foundation
import UIKit

class BannerCell: BaseCollectionViewCell {

  // MARK: - UIs

  let bannerImageView = UIImageView().then {
    $0.backgroundColor = .green
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 5
  }

  override func setupConstraints() {
    [self.bannerImageView].addSubViews(self.contentView)

    self.bannerImageView.snp.makeConstraints {
      $0.edges.equalTo(self.contentView)
    }
  }
}
