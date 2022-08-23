//
//  StoreListCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/22.
//

import UIKit

import SnapKit
import Then

final class StoreListCell: BaseCollectionViewCell {

  // MARK: - Properties

  private let promotions = ["텀블러 할인", "사은품 증정", "포인트 적립"]

  // MARK: - UIs

  private let thumbnailImageView = UIImageView().then {
    $0.backgroundColor = .gray20
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }

  private let storeNameLabel = UILabel().then {
    $0.text = "청담동 스타벅스"
    $0.font = .systemFont(ofSize: 15, weight: .semibold)
  }

  private let storeInfoLabel = UILabel().then {
    $0.text = "환경을 위한 다양한 프로모션이 준비 되어 있습니다."
    $0.numberOfLines = 1
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = .gray70
  }

  private let promotionStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 5
    $0.distribution = .fill
    $0.alignment = .bottom
  }

  private let separatorLineView = UIView().then {
    $0.backgroundColor = .gray30
  }

  // MARK: - Bind

  func setSeparatorLineView(isLast: Bool) {
    self.separatorLineView.isHidden = isLast
  }

  // MARK: - Configure

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

  override func setupConfigure() {
    self.setPromotionStackView(promotions: self.promotions)
  }

  override func setupConstraints() {
    [self.thumbnailImageView, self.storeNameLabel, self.storeInfoLabel, self.promotionStackView, self.separatorLineView].addSubViews(self.contentView)

    self.thumbnailImageView.snp.makeConstraints {
      $0.bottom.equalTo(self.contentView).offset(-15)
      $0.leading.equalTo(self.contentView)
      $0.width.height.equalTo(80)
    }

    self.storeInfoLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.thumbnailImageView.snp.centerY)
      $0.leading.equalTo(self.thumbnailImageView.snp.trailing).offset(10)
      $0.trailing.equalTo(self.contentView.snp.trailing)
    }

    self.storeNameLabel.snp.makeConstraints {
      $0.bottom.equalTo(self.storeInfoLabel.snp.top).offset(-5)
      $0.leading.equalTo(self.thumbnailImageView.snp.trailing).offset(10)
      $0.trailing.equalTo(self.contentView.snp.trailing)
    }

    self.promotionStackView.snp.makeConstraints {
      $0.leading.equalTo(self.thumbnailImageView.snp.trailing).offset(10)
      $0.top.equalTo(self.storeInfoLabel.snp.bottom).offset(5)
    }

    self.separatorLineView.snp.makeConstraints {
      $0.bottom.leading.trailing.equalTo(self.contentView)
      $0.height.equalTo(1)
    }
  }
}
