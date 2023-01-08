//
//  MyTableViewFooter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/18.
//

import UIKit

import SnapKit
import Then
import KKDSKit

final class MyTableViewFooter: BaseTableViewHeaderFooterView<MySection> {

  // MARK: - Constants

  private enum Metric {
    static let separatorViewHeight = 10.f
    static let separatorViewBottomMargin = -20.f
    static let separatorViewTopMargin = 20.f

    static let signOutButtonTopMargin = 30.f
    static let signOutButtonBottomMargin = -60.f
    static let signOutButtonWidth = 20.f
    static let signOutButtonHeight = 40.f
  }

  // MARK: - UIs

  private let separatorView = UIView().then {
    $0.backgroundColor = KKDS.Color.gray10
  }

  let signOutButton = KKDS.Button.MiddleButton.then {
    $0.setTitle("로그아웃", for: .normal)
  }

  // MARK: - Bind

  override func bind(_ model: MySection?) {
    let isLastSection = model?.title == .policy
    
    self.signOutButton.isHidden = !isLastSection
    self.separatorView.isHidden = isLastSection
  }

  // MARK: - Configure

  func setSignOutButtonHiddenStatus(isSignedIn: Bool) {
    if !self.signOutButton.isHidden {
        self.signOutButton.isHidden = !isSignedIn
    }
  }

  // MARK: - Constraints
  
  override func setupConstraints() {
    [self.separatorView, self.signOutButton].addSubViews(self)

    self.separatorView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.top.equalToSuperview().offset(Metric.separatorViewTopMargin)
      $0.height.equalTo(Metric.separatorViewHeight)
      $0.bottom.equalToSuperview().offset(Metric.separatorViewBottomMargin)
    }

    self.signOutButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(Metric.signOutButtonTopMargin)
      $0.bottom.equalToSuperview().offset(Metric.signOutButtonBottomMargin)
      $0.height.equalTo(Metric.signOutButtonHeight)
      $0.width.equalToSuperview().inset(Metric.signOutButtonWidth)
    }
  }
}
