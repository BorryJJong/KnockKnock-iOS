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

final class MyCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let titleLabelLeadingMargin = 20.f

    static let enterButtonTrailingMargin = 20.f
  }

  // MARK: - UI

  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 15, weight: .bold)
    $0.text = "프로필 수정"
    $0.textColor = .black
  }

  private let enterButton = UIButton().then {
    $0.setImage(KKDS.Image.ic_left_10_gr, for: .normal)
    $0.setTitleColor(KKDS.Color.gray70, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
    $0.semanticContentAttribute = .forceRightToLeft
  }

  private let alertSwitch = UISwitch().then {
    $0.onTintColor = KKDS.Color.green50
    $0.isOn = false
  }

  // MARK: - Bind

  func bind(
    title: String,
    isSwitch: Bool,
    isVersion: Bool,
    versionInfo: String
  ) {
    self.titleLabel.text = title

    self.enterButton.isHidden = isSwitch
    self.alertSwitch.isHidden = !isSwitch

    if isVersion {
      self.enterButton.setTitle("V \(versionInfo) ", for: .normal)
    } else{
      self.enterButton.setTitle(nil, for: .normal)
    }
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.titleLabel, self.enterButton, self.alertSwitch].addSubViews(self.contentView)

    self.titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(Metric.titleLabelLeadingMargin)
      $0.centerY.equalToSuperview()
    }

    self.enterButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(Metric.enterButtonTrailingMargin)
      $0.centerY.equalTo(self.titleLabel)
    }

    self.alertSwitch.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(Metric.enterButtonTrailingMargin)
      $0.centerY.equalTo(self.titleLabel)
    }
  }
}
