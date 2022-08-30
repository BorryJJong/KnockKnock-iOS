//
//  SearchResultCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/30.
//

import UIKit

import Then
import SnapKit
import KKDSKit

class SearchResultCell: BaseCollectionViewCell {

  // MARK: - UIs

  private let imageView = UIImageView().then {
    $0.image = KKDS.Image.ic_search_location_52
  }

  private let dataLabel = UILabel().then {
    $0.text = "text!!"
    $0.numberOfLines = 1
  }

  private let deleteButton = UIButton().then {
    $0.setImage(KKDS.Image.ic_close_10_gr, for: .normal)
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.imageView, self.dataLabel, self.deleteButton].addSubViews(self.contentView)

    self.imageView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(5)
      $0.leading.equalToSuperview().offset(20)
      $0.width.height.equalTo(52)
    }

    self.dataLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.imageView.snp.centerY)
      $0.leading.equalTo(self.imageView.snp.trailing).offset(20)
      $0.trailing.equalTo(self.deleteButton.snp.leading).offset(-10)
    }

    self.deleteButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalTo(self.imageView.snp.centerY)
    }
  }
}
