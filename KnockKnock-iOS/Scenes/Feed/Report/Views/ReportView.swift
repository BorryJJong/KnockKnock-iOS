//
//  reportView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/06.
//

import UIKit

import SnapKit
import KKDSKit
import Then

final class ReportView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let headerLabelTopMargin = 20.f
    static let headerLabelLeadingMargin = 20.f

    static let reportTableViewTopMargin = 15.f
    static let reportTableViewLeadingMargin = 10.f
    static let reportTableViewBottomMargin = -50.f

    static let reportButtonBottomMargin = -10.f
    static let reportButtonLeadingMargin = 20.f
    static let reportButtonHeight = 45.f
  }

  // MARK: - UI

  private let headerLabel = UILabel().then {
    $0.text = "신고 사유를 선택해주세요 (필수)"
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
    $0.textColor = KKDS.Color.gray70
  }

  let reportTableView = UITableView(
    frame: .zero,
    style: .plain
  ).then {
    $0.isScrollEnabled = false
    $0.separatorColor = .clear
    $0.backgroundColor = .white
    $0.rowHeight = UITableView.automaticDimension
    $0.registCell(type: ReportCell.self)
    $0.register(type: ReportTableFooterView.self)
  }

  let reportButton = KKDSLargeButton().then {
    $0.setTitle("신고", for: .normal)
  }

  // MARK: - Initialize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  private func setupConstraints() {
    [self.headerLabel, self.reportTableView, self.reportButton].addSubViews(self)

    self.headerLabel.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(Metric.headerLabelTopMargin)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.headerLabelLeadingMargin)
    }

    self.reportButton.snp.makeConstraints {
      $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(Metric.reportButtonBottomMargin)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.reportButtonLeadingMargin)
      $0.height.equalTo(Metric.reportButtonHeight)
    }

    self.reportTableView.snp.makeConstraints {
      $0.top.equalTo(headerLabel.snp.bottom).offset(Metric.reportTableViewTopMargin)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.reportTableViewLeadingMargin)
      $0.bottom.equalTo(self.reportButton.snp.top).offset(Metric.reportTableViewBottomMargin)
    }
  }
}
