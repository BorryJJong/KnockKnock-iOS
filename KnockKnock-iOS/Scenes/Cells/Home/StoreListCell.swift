//
//  StoreListCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/22.
//

import UIKit

import KKDSKit
import SnapKit
import Then

final class StoreListCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let thumbnailImageViewBottomMargin = -15.f
    static let thumbnailImageViewWidth = 80.f

    static let storeInfoLabelLeadingMargin = 10.f

    static let storeNameLabelBottomMargin = -5.f
    static let storeNameLabelLeadingMargin = 10.f

    static let promotionViewLeadingMargin = 10.f
    static let promotionViewTopMargin = 5.f

    static let separatorLineViewHeight = 1.f
  }

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

  private let promotionView = UIView()

  private let separatorLineView = UIView().then {
    $0.backgroundColor = .gray30
  }

  // MARK: - Bind

  func setSeparatorLineView(isLast: Bool) {
    self.separatorLineView.isHidden = isLast
  }

  func bind(store: StoreDetail) {
    self.thumbnailImageView.setImageFromStringUrl(
      stringUrl: store.image,
      defaultImage: KKDS.Image.ic_no_data_60
    )
    self.storeNameLabel.text = store.name
    self.storeInfoLabel.text = store.description
    self.setPromotionView(promotions: store.shopPromotionNames)
  }

  // MARK: - Constraints

  override func setupConstraints() {
    [self.thumbnailImageView, self.storeNameLabel, self.storeInfoLabel, self.promotionView, self.separatorLineView].addSubViews(self.contentView)

    self.thumbnailImageView.snp.makeConstraints {
      $0.bottom.equalTo(self.contentView).offset(Metric.thumbnailImageViewBottomMargin)
      $0.leading.equalTo(self.contentView)
      $0.width.height.equalTo(Metric.thumbnailImageViewWidth)
    }

    self.storeInfoLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.thumbnailImageView.snp.centerY)
      $0.leading.equalTo(self.thumbnailImageView.snp.trailing).offset(Metric.storeInfoLabelLeadingMargin)
      $0.trailing.equalTo(self.contentView.snp.trailing)
    }

    self.storeNameLabel.snp.makeConstraints {
      $0.bottom.equalTo(self.storeInfoLabel.snp.top).offset(Metric.storeNameLabelBottomMargin)
      $0.leading.equalTo(self.thumbnailImageView.snp.trailing).offset(Metric.storeNameLabelLeadingMargin)
      $0.trailing.equalTo(self.contentView.snp.trailing)
    }

    self.promotionView.snp.makeConstraints {
      $0.leading.equalTo(self.thumbnailImageView.snp.trailing).offset(Metric.promotionViewLeadingMargin)
      $0.trailing.equalTo(self.contentView)
      $0.top.equalTo(self.storeInfoLabel.snp.bottom).offset(Metric.promotionViewTopMargin)
    }

    self.separatorLineView.snp.makeConstraints {
      $0.bottom.leading.trailing.equalTo(self.contentView)
      $0.height.equalTo(Metric.separatorLineViewHeight)
    }
  }
}

extension StoreListCell {

  /// contentView 길이만큼 label 추가
  private func setPromotionView(promotions: [String]) {
    var totalLength = 0.f
    let maxLength = self.contentView.frame.width - (Metric.thumbnailImageViewWidth + 15)

    for index in 0..<promotions.count {

      let label = BasePaddingLabel(
        padding: UIEdgeInsets(
          top: 5,
          left: 5,
          bottom: 5,
          right: 5
        )
      ).then {
        $0.text = promotions[index]
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .gray70
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .gray20
        $0.sizeToFit()
      }

      if totalLength + label.bounds.width < maxLength {
        self.promotionView.addSubview(label)

        label.snp.makeConstraints {
          $0.leading.equalTo(self.promotionView).offset(totalLength)
          $0.top.bottom.equalTo(self.promotionView)
        }

        totalLength += label.bounds.width + 15
      }

      if index == 2 { break }
    }
  }
}
