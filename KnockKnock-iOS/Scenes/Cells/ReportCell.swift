//
//  ReportCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/06.
//

import UIKit

import KKDSKit
import SnapKit
import Then

final class ReportCell: BaseTableViewCell<Report> {

  // MARK: - Properties

  private enum Metric {
    static let checkImageViewInset = 10.f

    static let reportTypeLabelLeadingMargin = 10.f
    static let reportTypeLabelTrailingMargin = 10.f
  }

  // MARK: - UI

  private let reportTypeLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
  }

  private let checkImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_checkbox_20_off
  }

  // MARK: - Bind

  override func bind(_ model: Report?) {
    super.bind(model)

    guard let model = model else { return }

    self.checkImageView.image = model.isSelected
    ? KKDS.Image.ic_checkbox_20_on
    : KKDS.Image.ic_checkbox_20_off

    self.reportTypeLabel.text = model.reportType.message
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.checkImageView, self.reportTypeLabel].addSubViews(self.contentView)

    self.checkImageView.snp.makeConstraints {
      $0.leading.top.bottom.equalTo(self.contentView).inset(Metric.checkImageViewInset)
      $0.height.equalTo(self.checkImageView.snp.width)
    }

    self.reportTypeLabel.snp.makeConstraints {
      $0.leading.equalTo(self.checkImageView.snp.trailing).offset(Metric.reportTypeLabelLeadingMargin)
      $0.trailing.equalTo(self.contentView).inset(Metric.reportTypeLabelTrailingMargin)
      $0.centerY.equalTo(self.checkImageView)
    }
  }
}
