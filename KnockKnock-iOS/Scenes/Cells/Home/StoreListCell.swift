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

  // MARK: - Constants

  private enum Metric {
    static let thumbnailImageViewBottomMargin = -15.f
    static let thumbnailImageViewWidth = 80.f

    static let storeInfoLabelLeadingMargin = 10.f

    static let storeNameLabelBottomMargin = -5.f
    static let storeNameLabelLeadingMargin = 10.f

    static let promotionStackViewLeadingMargin = 10.f
    static let promotionStackViewTopMargin = 5.f

    static let separatorLineViewHeight = 1.f
  }

  // MARK: - Properties

  private let promotions = ["텀블러 할인", "사은품 증정", "포인트 적립", "텀블러 할인", "포인트 적립", "텀블러 할인"]

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

  private let promotionsView = UIView()

  private let separatorLineView = UIView().then {
    $0.backgroundColor = .gray30
  }

  // MARK: - Bind

  func setSeparatorLineView(isLast: Bool) {
    self.separatorLineView.isHidden = isLast
  }

  // MARK: - Configure

  private func setPromotionView(promotions: [String]) -> [UILabel] {
    var labels: [UILabel] = []

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
      labels.append(label)
    }
    return labels
  }

  private func setPromotionStackView(promotions: [String]) {

    let labels = self.setPromotionView(promotions: promotions)
    var totalLength = -5.f

    for index in 0..<labels.count {
      self.promotionsView.addSubview(labels[index])

      if index == 0 {
        labels[index].snp.makeConstraints {
          $0.leading.equalToSuperview()
          $0.top.bottom.equalToSuperview()
        }
      } else {
        labels[index].snp.makeConstraints {
          $0.leading.equalTo(labels[index-1].snp.trailing).offset(5)
          $0.top.bottom.equalToSuperview()
        }
      }

      if let nsStringText = NSString(utf8String: labels[index].text ?? "") {
        let labelWidth = nsStringText.size(
          withAttributes: [
            NSAttributedString.Key.font : labels[index].font
          ]
        ).width
        totalLength += labelWidth + 5
      }

      if totalLength > (self.contentView.frame.width - 135) {
        labels[index].snp.makeConstraints {
          $0.trailing.equalToSuperview()
        }
        break
      }
    }
  }

  override func setupConfigure() {
    self.setPromotionStackView(promotions: self.promotions)
  }

  override func setupConstraints() {
    [self.thumbnailImageView, self.storeNameLabel, self.storeInfoLabel, self.promotionsView, self.separatorLineView].addSubViews(self.contentView)

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

    self.promotionsView.snp.makeConstraints {
      $0.leading.equalTo(self.thumbnailImageView.snp.trailing).offset(Metric.promotionStackViewLeadingMargin)
      $0.trailing.equalTo(self.contentView.snp.trailing)
      $0.top.equalTo(self.storeInfoLabel.snp.bottom).offset(Metric.promotionStackViewTopMargin)
    }

    self.separatorLineView.snp.makeConstraints {
      $0.bottom.leading.trailing.equalTo(self.contentView)
      $0.height.equalTo(Metric.separatorLineViewHeight)
    }
  }
}
