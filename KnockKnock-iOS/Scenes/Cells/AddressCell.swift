//
//  AddressCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/21.
//

import UIKit

import KKDSKit
import SnapKit

final class AdressCell: BaseTableViewCell<Void> {

  // MARK: - Constants

  private enum Metric {
    static let iconImageViewBottomMargin = -15.f
    static let iconImageViewLeadingMargin = 20.f

    static let addressLabelLeadingMargin = 10.f
  }

  // MARK: - UI

  let iconImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_search_location_52
  }

  let shopNameLabel = UILabel().then {
    $0.text = "매장명"
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
  }

  let addressLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .medium)
  }

  // MARK: - Bind

  func bind(address: String) {
    self.addressLabel.text = address
  }

  // MARK: - Constraints

  override func setupConstraints() {
    [self.iconImageView, self.shopNameLabel, self.addressLabel].addSubViews(self.contentView)

    iconImageView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(5)
      $0.leading.equalToSuperview()
      $0.width.equalTo(self.iconImageView.snp.height)
    }

    shopNameLabel.snp.makeConstraints {
      $0.bottom.equalTo(self.iconImageView.snp.centerY).offset(-5)
      $0.leading.equalTo(self.iconImageView.snp.trailing).offset(Metric.addressLabelLeadingMargin)
      $0.trailing.equalToSuperview()
    }

    addressLabel.snp.makeConstraints {
      $0.top.equalTo(self.iconImageView.snp.centerY).offset(5)
      $0.leading.equalTo(self.iconImageView.snp.trailing).offset(Metric.addressLabelLeadingMargin)
      $0.trailing.equalToSuperview()
    }
  }
}
