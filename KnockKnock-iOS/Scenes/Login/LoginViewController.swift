//
//  LoginViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/06.
//

import UIKit

import Then
import KakaoSDKUser

final class LoginViewController: BaseViewController<LoginView> {

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.containerView.kakaoLoginButton.addTarget(
      self,
      action: #selector(self.kakaoLoginButtonDidTap(_:)),
      for: .touchUpInside
    )
  }

  // MARK: - Button Actions

  @objc func kakaoLoginButtonDidTap(_ sender: UIButton) {
    if (UserApi.isKakaoTalkLoginAvailable()) {
      UserApi.shared.loginWithKakaoTalk(completion: { (oauthToken, error) in
        if let error = error {
          print(error)
        } else {
          _ = oauthToken
        }
      })
    }
  }
}
