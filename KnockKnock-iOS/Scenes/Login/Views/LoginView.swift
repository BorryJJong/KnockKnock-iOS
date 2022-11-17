//
//  LoginView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/06.
//

import UIKit

import SnapKit
import Then
import KKDSKit

final class LoginView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let kakaoLoginButonLeadingMargin = 20.f
  }

  // MARK: - UIs

  private let titleLabel = UILabel().then {
    $0.text = "로그인 및 회원가입"
    $0.font = .systemFont(ofSize: 26, weight: .bold)
    $0.textColor = .black
  }

  private let subTitleLabel = UILabel().then {
    $0.text = "복잡한 절차 없이 SNS 계정으로 간편하게\n제로웨이스트를 시작하세요."
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = .gray70
    $0.numberOfLines = 0
  }

  let kakaoLoginButton = UIButton().then {
    $0.setImage(KKDS.Image.ic_kakao_login, for: .normal)
    $0.contentMode = .scaleAspectFit
  }

  // 테스트용 로그아웃 버튼
  let logoutButton = UIButton().then {
    $0.backgroundColor = .black
    $0.setTitle("LOGOUT", for: .normal)
    $0.contentMode = .scaleAspectFit
  }

  // MARK: - Initialize

  override init(frame: CGRect) {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Configure

  private func setupConstraints() {
    [self.kakaoLoginButton, self.logoutButton, self.titleLabel, self.subTitleLabel].addSubViews(self)

    self.kakaoLoginButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(Metric.kakaoLoginButonLeadingMargin)
      $0.height.equalTo(45)
      $0.centerY.equalToSuperview()
    }

    self.logoutButton.snp.makeConstraints {
      $0.height.equalTo(45)
      $0.leading.trailing.equalTo(self.kakaoLoginButton)
      $0.top.equalTo(self.kakaoLoginButton.snp.bottom).offset(50)
    }

    self.titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(self.kakaoLoginButton.snp.top).offset(-125)
    }

    self.subTitleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
    }
  }
}
