//
//  FeedSearchResultFooterReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/31.
//

import UIKit

import Then
import SnapKit

final class FeedSearchResultFooterReusableView: UICollectionReusableView {

  // MARK: - Constants

  private enum Metric {
    static let lineViewTopMargin = 10.f
    static let lineViewBottomMargin = -15.f
    static let lineViewHeight = 1.f
  }

  // MARK: - UIs

  private let lineView = UIView().then {
    $0.backgroundColor = .gray20
  }

  // MARK: - Initialize

  override init(frame: CGRect) {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Bind

  func bind(isHeader: Bool) {
    self.lineView.isHidden = isHeader
  }

  // MARK: - Configure

  private func setupConstraints() {
    [self.lineView].addSubViews(self)

    self.lineView.snp.makeConstraints {
      $0.trailing.leading.equalToSuperview()
      $0.top.equalToSuperview().offset(Metric.lineViewTopMargin)
      $0.bottom.equalToSuperview().offset(Metric.lineViewBottomMargin)
      $0.height.equalTo(Metric.lineViewHeight)
    }
  }
}
