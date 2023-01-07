//
//  PostFooterReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/27.
//

import UIKit

import KKDSKit
import SnapKit

final class PostFooterReusableView: UICollectionReusableView {

  // MARK: - Constants

  private enum Metric {
    static let shopInfoViewTopMargin = 15.f
    static let shopInfoViewLeadingMargin = 20.f
    static let shopInfoViewTrailingMargin = -20.f
    static let shopInfoViewBottomMargin = -30.f

    static let markImageViewTopMargin = 15.f
    static let markImageViewLeadingMarin = 20.f

    static let shopNameLabelLeadingMargin = 10.f

    static let shopAddressLabelTopMargin = 5.f
    static let shopAddressLabelLeadingMargin = 20.f
    static let shopAddressLabelBottomMargin = -15.f

    static let separateLineViewHeight = 10.f
    static let separateLineViewTopMargin = 30.f
  }

  // MARK: - UIs

  private let shopInfoView = UIView().then {
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray20?.cgColor
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 3
  }

  private let markImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_location_20
  }

  private let shopNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .bold)
    $0.textColor = .gray80
  }

  private let shopAddressLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = .gray60
  }

  private let separateLineView = UIView().then {
    $0.backgroundColor = .gray10
  }

  // MARK: - Initailize

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Bind

  func bind(
    name: String?,
    address: String?
  ) {
    guard let name = name,
          let address = address else { return }
    
    self.setShopInfoViewConstraints()

    self.shopNameLabel.text = name
    self.shopAddressLabel.text = address

    self.layoutIfNeeded()
  }

  // MARK: - Constraints

  private func setShopInfoViewConstraints() {
    [self.shopInfoView].addSubViews(self)
    [self.markImageView, self.shopNameLabel, self.shopAddressLabel].addSubViews(self.shopInfoView)

    self.separateLineView.snp.remakeConstraints {
      $0.height.equalTo(Metric.separateLineViewHeight)
      $0.leading.trailing.bottom.equalTo(self)
    }

    self.shopInfoView.snp.makeConstraints {
      $0.top.equalTo(self).offset(Metric.shopInfoViewTopMargin)
      $0.leading.equalTo(self).offset(Metric.shopInfoViewLeadingMargin)
      $0.trailing.equalTo(self).offset(Metric.shopInfoViewTrailingMargin)
      $0.bottom.equalTo(self.separateLineView.snp.top).offset(Metric.shopInfoViewBottomMargin)
    }

    self.markImageView.snp.makeConstraints {
      $0.top.equalTo(self.shopInfoView).offset(Metric.markImageViewTopMargin)
      $0.leading.equalTo(self.shopInfoView).offset(Metric.markImageViewLeadingMarin)
    }

    self.shopNameLabel.snp.makeConstraints {
      $0.leading.equalTo(self.markImageView.snp.trailing).offset(Metric.shopNameLabelLeadingMargin)
      $0.centerY.equalTo(self.markImageView)
    }

    self.shopAddressLabel.snp.makeConstraints {
      $0.leading.equalTo(self.shopInfoView).offset(Metric.shopAddressLabelLeadingMargin)
      $0.top.equalTo(self.markImageView.snp.bottom).offset(Metric.shopAddressLabelTopMargin)
      $0.bottom.equalTo(self.shopInfoView).offset(Metric.shopAddressLabelBottomMargin)
    }
  }

  private func setupConstraints() {
    [self.separateLineView].addSubViews(self)

    self.separateLineView.snp.makeConstraints {
      $0.top.equalTo(self).offset(Metric.separateLineViewTopMargin)
      $0.height.equalTo(Metric.separateLineViewHeight)
      $0.leading.trailing.bottom.equalTo(self)
    }
  }
}
