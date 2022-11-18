//
//  MyCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/05.
//

import UIKit

import SnapKit
import KKDSKit
import Then

final class MyCell: BaseTableViewCell<MyItem> {

  // MARK: - Constants

  private enum Metric {
    static let titleLabelLeadingMargin = 20.f

    static let versionLabelTrailingMargin = 5.f

    static let alertSwitchTrailingMargin = 20.f
  }

  // MARK: - UI

  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 15, weight: .bold)
    $0.textColor = .black
  }

  private let versionLabel = UILabel().then {
    $0.text = "V 0.1.1"
    $0.textColor = KKDS.Color.gray70
    $0.font = .systemFont(ofSize: 13, weight: .light)
  }

  private let alertSwitch = UISwitch().then {
    $0.onTintColor = KKDS.Color.green50
    $0.tintColor = KKDS.Color.gray20
    $0.isOn = false
  }

  // MARK: - Bind

  override func bind(_ model: MyItem?) {
    super.bind(model)

    let type = model?.type

    titleLabel.text = model?.title

    self.versionLabel.isHidden = !(type == .version)
    self.alertSwitch.isHidden = !(type == .alert)
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.titleLabel, self.versionLabel, self.alertSwitch].addSubViews(self.contentView)

    self.titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(Metric.titleLabelLeadingMargin)
      $0.centerY.equalToSuperview()
    }

    self.versionLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(Metric.versionLabelTrailingMargin)
      $0.centerY.equalTo(self.titleLabel)
    }

    self.alertSwitch.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(Metric.alertSwitchTrailingMargin)
      $0.centerY.equalTo(self.titleLabel)
    }
  }
}
