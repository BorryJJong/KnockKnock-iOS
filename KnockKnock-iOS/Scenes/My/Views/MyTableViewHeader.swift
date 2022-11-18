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

final class MyTableViewHeader: UITableViewHeaderFooterView {

  // MARK: - Constants
  private enum Metric {
    static let titleLabelLeadingMargin = 20.f
    static let titleLabelTopMargin = 15.f
  }

  // MARK: - UIs

  private let titleLabel = UILabel().then {
    $0.text = "test"
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = KKDS.Color.gray70
  }

  // MARK: - Initailize
  
  override init(reuseIdentifier: String?) {
      super.init(reuseIdentifier: reuseIdentifier)
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Bind
  func bind(title: String) {
    self.titleLabel.text = title
  }

  // MARK: - Constraints
  private func setupConstraints() {
    [self.titleLabel].addSubViews(self)

    self.titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(Metric.titleLabelLeadingMargin)
      $0.top.equalToSuperview().offset(Metric.titleLabelTopMargin)
      $0.bottom.equalToSuperview().offset(-10)
    }
  }

}
