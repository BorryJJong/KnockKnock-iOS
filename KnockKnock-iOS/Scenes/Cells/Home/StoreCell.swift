//
//  StoreCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/02.
//

import UIKit

import SnapKit

class StoreCell: BaseCollectionViewCell {

  // MARK: - Properties

  let promotions = ["텀블러 할인", "사은품 증정", "포인트 적립"]

  // MARK: - UIs

  let storeImageView = UIImageView().then {
    $0.image = UIImage(named: "feed_sample_1")
    $0.layer.cornerRadius = 5
    $0.backgroundColor = .darkGray
    $0.contentMode = .scaleToFill
    $0.clipsToBounds = true
  }

  let storeNameLabel = UILabel().then {
    $0.text = "청담동 스타벅스"
    $0.font = .systemFont(ofSize: 15, weight: .semibold)
  }

  let storeInfoLabel = UILabel().then {
    $0.text = "환경을위한 다양한 프로모션 전문 상점"
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = .gray70
  }

  let promotionStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 5
    $0.distribution = .equalSpacing
  }

  func setPromotionStackView(promotions: [String]) {
    for index in 0..<promotions.count {
      let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)).then {
        $0.text = promotions[index]
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .gray70
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .gray20
      }
      if index == promotions.count - 1 {
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
      }

      self.promotionStackView.addArrangedSubview(label)
    }
  }

  override func setupConstraints() {
    self.setPromotionStackView(promotions: self.promotions)
    [self.storeImageView, self.storeNameLabel, self.storeInfoLabel, self.promotionStackView].addSubViews(self.contentView)

    self.storeImageView.snp.makeConstraints {
      $0.top.leading.equalTo(self.contentView)
      $0.width.height.equalTo(150)
    }

    self.storeNameLabel.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.contentView)
      $0.top.equalTo(self.storeImageView.snp.bottom).offset(20)
    }

    self.storeInfoLabel.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.contentView)
      $0.top.equalTo(self.storeNameLabel.snp.bottom).offset(5)
    }

    self.promotionStackView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.contentView)
      $0.top.equalTo(self.storeInfoLabel.snp.bottom).offset(10)
    }

  }
}
