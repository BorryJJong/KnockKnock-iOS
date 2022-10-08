//
//  SettingCollectionReuasbleHeaderView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/07.
//

import UIKit

import Then
import KKDSKit
import SnapKit

final class SettingHeaderCollectionReusableView: UICollectionReusableView {

  // MARK: - Constants

  private enum Metric {
    static let titleLabelLeadingMargin = 20.f
    static let titleLabelTopMargin = 15.f
  }


  // MARK: - UIs
  
  private let titleLabel = UILabel().then {
    $0.text = "test"
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = .gray70
  }

  // MARK: - Initailize

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
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
      $0.bottom.equalToSuperview()
    }
  }
}
