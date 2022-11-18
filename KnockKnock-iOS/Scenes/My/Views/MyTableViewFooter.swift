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

final class MyTableViewFooter: UITableViewHeaderFooterView {

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

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Bind

  func bind(section: MySection) {
    let isLastSection = section == .policy
    
    self.logoutButton.isHidden = !isLastSection
    self.separatorView.isHidden = isLastSection
  }

  // MARK: - Constraints
  
  private func setupConstraints() {
    [self.separatorView, self.logoutButton].addSubViews(self)

    self.separatorView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.top.equalToSuperview().offset(20)
      $0.height.equalTo(Metric.separatorViewHeight)
      $0.bottom.equalToSuperview().offset(Metric.separatorViewBottomMargin)
    }

    self.logoutButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(Metric.logoutButtonTopMargin)
      $0.bottom.equalToSuperview().offset(Metric.logoutButtonBottomMargin)
      $0.height.equalTo(40)
      $0.width.equalToSuperview().inset(Metric.logoutButtonWidth)
    }
  }
}
