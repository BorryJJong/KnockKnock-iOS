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
    $0.contentMode = .scaleToFill
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
    [self.mainImageView].addSubViews(self.contentView)

    self.mainImageView.snp.makeConstraints {
      $0.edges.equalTo(self.contentView)
    }
  }
}
