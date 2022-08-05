//
//  StoreCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/02.
//

import UIKit

import SnapKit

class StoreCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let storeImageViewWidth = 150.f

    static let storeNameLabelTopMargin = 20.f

    static let storeInfoLabelTopMargin = 5.f

    static let promotionStackViewTopMargin = 10.f
  }

  // MARK: - Properties

  private let promotions = ["텀블러 할인", "사은품 증정", "포인트 적립"]

  // MARK: - UIs

  private let storeImageView = UIImageView().then {
    $0.image = UIImage(named: "feed_sample_1")
    $0.layer.cornerRadius = 5
    $0.backgroundColor = .darkGray
    $0.contentMode = .scaleToFill
    $0.clipsToBounds = true
  }

  private let storeNameLabel = UILabel().then {
    $0.text = "청담동 스타벅스"
    $0.font = .systemFont(ofSize: 15, weight: .semibold)
    $0.numberOfLines = 1
  }

  private let storeInfoLabel = UILabel().then {
    $0.text = "환경을위한 다양한 프로모션 전문 상점"
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = .gray70
    $0.numberOfLines = 1
  }

  private let promotionStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 5
    $0.distribution = .fill
    $0.alignment = .bottom
  }

  private func setPromotionStackView(promotions: [String]) {
    for index in 0..<promotions.count {
      let label = BasePaddingLabel(
        padding: UIEdgeInsets(
          top: 5,
          left: 5,
          bottom: 5,
          right: 5
        )).then {
          $0.text = promotions[index]
          $0.font = .systemFont(ofSize: 10)
          $0.textColor = .gray70
          $0.clipsToBounds = true
          $0.layer.cornerRadius = 5
          $0.backgroundColor = .gray20
        }
      if index == promotions.count - 1 {
        label.setContentCompressionResistancePriority(
          UILayoutPriority.defaultLow,
          for: .horizontal
        )
      }
      self.promotionStackView.addArrangedSubview(label)
    }
  }

  override func setupConstraints() {
    self.setPromotionStackView(promotions: self.promotions)
    [self.storeImageView, self.storeNameLabel, self.storeInfoLabel, self.promotionStackView].addSubViews(self.contentView)

    self.storeImageView.snp.makeConstraints {
      $0.top.leading.equalTo(self.contentView)
      $0.width.height.equalTo(Metric.storeImageViewWidth)
    }

    self.storeNameLabel.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.contentView)
      $0.top.equalTo(self.storeImageView.snp.bottom).offset(Metric.storeNameLabelTopMargin)
    }

    self.storeInfoLabel.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.contentView)
      $0.top.equalTo(self.storeNameLabel.snp.bottom).offset(Metric.storeInfoLabelTopMargin)
    }

    self.promotionStackView.snp.makeConstraints {
      $0.leading.bottom.trailing.equalTo(self.contentView)
      $0.top.equalTo(self.storeInfoLabel.snp.bottom).offset(Metric.promotionStackViewTopMargin)
    }
  }
}
