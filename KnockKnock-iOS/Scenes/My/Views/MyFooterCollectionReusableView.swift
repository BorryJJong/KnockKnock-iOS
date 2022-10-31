//
//  MyFooterCollectionReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/08.
//

import UIKit

import SnapKit
import Then
import KKDSKit

final class MyFooterCollectionReusableView: UICollectionReusableView {

  // MARK: - Constants

  private enum Metric {
    static let separatorViewHeight = 10.f
    static let separatorViewBottomMargin = -20.f

    static let logoutButtonTopMargin = 30.f
    static let logoutButtonBottomMargin = -60.f
    static let logoutButtonWidth = 20.f
  }

  // MARK: - UIs
  private let separatorView = UIView().then {
    $0.backgroundColor = KKDS.Color.gray10
  }

  let logoutButton = MiddleButton(title: "로그아웃")

  // MARK: - Initailize

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Bind

  func bind(isLast: Bool) {
    self.logoutButton.isHidden = !isLast
    self.separatorView.isHidden = isLast
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.separatorView, self.logoutButton].addSubViews(self)

    self.separatorView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(Metric.separatorViewHeight)
      $0.bottom.equalToSuperview().offset(Metric.separatorViewBottomMargin)
    }

    self.logoutButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(Metric.logoutButtonTopMargin)
      $0.bottom.equalToSuperview().offset(Metric.logoutButtonBottomMargin)
      $0.width.equalToSuperview().inset(Metric.logoutButtonWidth)
    }
  }

}
