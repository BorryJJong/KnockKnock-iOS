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

  // MARK: - UIs

  let kakaoLoginButton = UIButton().then {
    $0.setImage(KKDS.Image.ic_kakao_login, for: .normal)
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
    [self.kakaoLoginButton].addSubViews(self)

    self.kakaoLoginButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.centerY.equalToSuperview()
    }
  }

}
