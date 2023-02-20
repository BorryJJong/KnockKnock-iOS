//
//  StoreCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/02.
//

import UIKit

import SnapKit
import Then
import KKDSKit

final class StoreCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let storeImageViewWidth = 150.f

    static let storeNameLabelTopMargin = 20.f

    static let storeInfoLabelTopMargin = 5.f

    static let promotionStackViewTopMargin = 10.f
  }

  // MARK: - UIs

  private let storeImageView = UIImageView().then {
    $0.layer.cornerRadius = 5
    $0.contentMode = .scaleToFill
    $0.clipsToBounds = true
  }

  private let storeNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 15, weight: .semibold)
    $0.numberOfLines = 1
  }

  private let storeInfoLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = .gray70
    $0.numberOfLines = 1
  }

  private let promotionView = UIView()

  // MARK: - Bind

  func bind(store: Store) {
    self.storeImageView.setImageFromStringUrl(
      stringUrl: store.image,
      defaultImage: KKDS.Image.ic_no_data_60
    )
    self.setPromotionView(promotions: store.shopPromotionNames)
    self.storeNameLabel.text = store.name
    self.storeInfoLabel.text = store.description
  }

  // MARK: - Constraints

  override func setupConstraints() {

    [self.storeImageView, self.storeNameLabel, self.storeInfoLabel, self.promotionView].addSubViews(self.contentView)

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

    self.promotionView.snp.makeConstraints {
      $0.leading.bottom.trailing.equalTo(self.contentView)
      $0.top.equalTo(self.storeInfoLabel.snp.bottom).offset(Metric.promotionStackViewTopMargin)
    }
  }
}

extension StoreCell {

  /// contentView 길이만큼 label 추가
  private func setPromotionView(promotions: [String]) {

    var totalLength = 0.f

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

      if totalLength + label.bounds.width < Metric.storeImageViewWidth - 15 {
        self.promotionView.addSubview(label)

        label.snp.makeConstraints {
          $0.leading.equalTo(self.promotionView).offset(totalLength)
          $0.top.bottom.equalTo(self.promotionView)
        }

        totalLength += label.bounds.width + 15
      }
    }
  }
}
