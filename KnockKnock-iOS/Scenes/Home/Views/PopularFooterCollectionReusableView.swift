//
//  PopularFooterCollectionReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/05.
//

import Foundation

import Then
import SnapKit
import KKDSKit

final class PopularFooterCollectionReusableView: UICollectionReusableView {

  // MARK: - Constants

  private enum Metric {
    static let morePostButtonleadingMargin = 20.f
    static let morePostHeight = 40.f

    static let seperatorViewTopMargin = 40.f
    static let seperatorViewHeight = 8.f
    static let seperatorViewBottomMargin = -20.f
  }

  // MARK: - UIs

  let morePostButton = KKDSMiddleButton().then {
    $0.setTitle("더 많은 게시글 살펴보기", for: .normal)
  }

  private let seperatorView = UIView().then {
    $0.backgroundColor = KKDS.Color.gray10
  }

  // MARK: - Initailize

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.morePostButton, self.seperatorView].addSubViews(self)

    self.morePostButton.snp.makeConstraints {
      $0.top.equalTo(self)
      $0.leading.trailing.equalTo(self).inset(Metric.morePostButtonleadingMargin)
      $0.height.equalTo(Metric.morePostHeight)
    }

    self.seperatorView.snp.makeConstraints {
      $0.top.equalTo(self.morePostButton.snp.bottom).offset(Metric.seperatorViewTopMargin)
      $0.leading.trailing.equalTo(self)
      $0.height.equalTo(Metric.seperatorViewHeight)
      $0.bottom.equalTo(self.snp.bottom).offset(Metric.seperatorViewBottomMargin)
    }
  }
}
