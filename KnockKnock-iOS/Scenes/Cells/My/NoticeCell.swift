//
//  NoticeCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/31.
//

import UIKit

import Then
import KKDSKit
import SnapKit

final class NoticeCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let titleLabelLeadingMargin = 20.f

    static let dateLabelLeadingMargin = 20.f
    static let dateLabelTopMargin = 3.f

    static let separatorLineViewLeadingMargin = 20.f
    static let separatorLineViewTopMargin = 20.f
    static let separatorLineViewHeight = 1.f
  }

  // MARK: - UIs

  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 15, weight: .bold)
    $0.numberOfLines = 1
  }

  private let dateLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = KKDS.Color.gray70
    $0.numberOfLines = 1
  }

  lazy var separatorLineView = UIView().then {
    $0.backgroundColor = KKDS.Color.gray20
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.titleLabel, self.dateLabel, self.separatorLineView].addSubViews(self.contentView)

    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(Metric.titleLabelLeadingMargin)
    }

    self.dateLabel.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.dateLabelTopMargin)
      $0.leading.trailing.equalToSuperview().inset(Metric.dateLabelLeadingMargin)
    }

    self.separatorLineView.snp.makeConstraints {
      $0.height.equalTo(Metric.separatorLineViewHeight)
      $0.top.equalTo(self.dateLabel.snp.bottom).offset(Metric.separatorLineViewTopMargin)
      $0.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(Metric.separatorLineViewLeadingMargin)
    }
  }
}
