//
//  ReportTableFooterView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/06.
//

import UIKit

import SnapKit
import Then
import KKDSKit

final class ReportTableFooterView: BaseTableViewHeaderFooterView<Void> {

  // MARK: - Constants

  private enum Metric {
    static let footerLabelTopMargin = 20.f
    static let footerLabelLeadingMargin = 10.f
  }

  // MARK: - UIs

  private let footerLabel = UILabel().then {
    $0.text = "신고해 주신 내용은 검토 후 내부 정책에 의거하여\n위반사항으로 확인 시 삭제처리 됩니다."
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = KKDS.Color.gray70
    $0.numberOfLines = 2
  }

  // MARK: - Constraints

  override func setupConstraints() {
    [self.footerLabel].addSubViews(self)

    self.footerLabel.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(Metric.footerLabelTopMargin)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.footerLabelLeadingMargin)
      $0.bottom.equalTo(self.safeAreaLayoutGuide)
    }
  }
}
