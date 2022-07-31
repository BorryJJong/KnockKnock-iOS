//
//  PostFooterReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/27.
//

import UIKit

import KKDSKit

class PostFooterReusableView: UICollectionReusableView {

  // MARK: - Constants

  private enum Metric {
    static let shopInfoViewTopMargin = 20.f
    static let shopInfoViewLeadingMargin = 20.f
    static let shopInfoViewTrailingMargin = -20.f
    static let shopInfoVIewBottomMargin = -30.f

    static let markImageViewTopMargin = 15.f
    static let markImageViewLeadingMaring = 20.f

    static let shopNameLabelLeadingMargin = 10.f

    static let shopAddressLabelTopMargin = 5.f
    static let shopAddressLabelLeadingMargin = 20.f
    static let shopAddressLabelBottomMargin = -15.f

    static let seperateLineViewHeight = 10.f
  }

  // MARK: - UIs

  private let shopInfoView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray20?.cgColor
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 3
  }

  private let markImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = KKDS.Image.ic_location_20
  }

  private let shopNameLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "아로마티카"
    $0.font = .systemFont(ofSize: 13, weight: .bold)
    $0.textColor = .gray80
  }

  private let shopAddressLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "서울특별시 강남구 신사동 613-15번지"
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = .gray60
  }

  private let seperateLineView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
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

  // MARK: - Constraints

  private func setupConstraints() {
    [self.shopInfoView].addSubViews(self)
    [self.markImageView, self.shopNameLabel, self.shopAddressLabel, self.seperateLineView].addSubViews(self)

    NSLayoutConstraint.activate([
      self.shopInfoView.topAnchor.constraint(equalTo: self.topAnchor, constant: Metric.shopInfoViewTopMargin),
      self.shopInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metric.shopInfoViewLeadingMargin),
      self.shopInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Metric.shopInfoViewTrailingMargin),
      self.shopInfoView.bottomAnchor.constraint(equalTo: self.seperateLineView.topAnchor, constant: Metric.shopInfoVIewBottomMargin),

      self.markImageView.topAnchor.constraint(equalTo: self.shopInfoView.topAnchor, constant: Metric.markImageViewTopMargin),
      self.markImageView.leadingAnchor.constraint(equalTo: self.shopInfoView.leadingAnchor, constant: Metric.markImageViewLeadingMaring),

      self.shopNameLabel.leadingAnchor.constraint(equalTo: self.markImageView.trailingAnchor, constant: Metric.shopNameLabelLeadingMargin),
      self.shopNameLabel.centerYAnchor.constraint(equalTo: self.markImageView.centerYAnchor),

      self.shopAddressLabel.leadingAnchor.constraint(equalTo: self.shopInfoView.leadingAnchor, constant: Metric.shopAddressLabelLeadingMargin),
      self.shopAddressLabel.topAnchor.constraint(equalTo: self.markImageView.bottomAnchor, constant: Metric.shopAddressLabelTopMargin),
      self.shopAddressLabel.bottomAnchor.constraint(equalTo: self.shopInfoView.bottomAnchor, constant: Metric.shopAddressLabelBottomMargin),

      self.seperateLineView.heightAnchor.constraint(equalToConstant: Metric.seperateLineViewHeight),
      self.seperateLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.seperateLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.seperateLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }

}
