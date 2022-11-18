//
//  MyTableHeaderView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/17.
//

import UIKit

import SnapKit
import Then
import KKDSKit

final class MyTableViewHeader: BaseTableViewHeaderFooterView<MyItemList> {

  // MARK: - Constants
  private enum Metric {
    static let titleLabelLeadingMargin = 20.f
    static let titleLabelTopMargin = 15.f
    static let titleLabelBottomMargin = -10.f
  }

  // MARK: - UIs

  private let titleLabel = UILabel().then {
    $0.text = "test"
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = KKDS.Color.gray70
  }

  // MARK: - Bind

  override func bind(_ model: MyItemList?) {
    super.bind(model)

    self.titleLabel.text = model?.section.rawValue
  }

  // MARK: - Constraints
  override func setupConstraints() {
    [self.titleLabel].addSubViews(self)

    self.titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(Metric.titleLabelLeadingMargin)
      $0.top.equalToSuperview().offset(Metric.titleLabelTopMargin)
      $0.bottom.equalToSuperview().offset(Metric.titleLabelBottomMargin)
    }
  }
}
