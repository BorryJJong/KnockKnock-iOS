//
//  LoginViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/06.
//

import UIKit

import Then

protocol LoginViewProtocol: AnyObject {
  func fetchLoginResult(loginResult: LoginResponse, loginInfo: LoginInfo)
}

final class LoginViewController: BaseViewController<LoginView> {

  var interactor: LoginInteractorProtocol?
  var router: LoginRouterProtocol?

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.navigationController?.navigationBar.setDefaultAppearance()

    self.containerView.kakaoLoginButton.addTarget(
      self,
      action: #selector(self.kakaoLoginButtonDidTap(_:)),
      for: .touchUpInside
    )
  }

  // MARK: - Button Actions

  @objc func kakaoLoginButtonDidTap(_ sender: UIButton) {
    self.interactor?.fetchLoginResult(socialType: SocialType.kakao)
  }
}

extension LoginViewController: LoginViewProtocol {
  func fetchLoginResult(
    loginResult: LoginResponse,
    loginInfo: LoginInfo
  ) {
    if loginResult.isExistUser {
      print("login success")
    } else {
      self.router?.navigateToProfileSettingView(source: self, loginInfo: loginInfo)
    }
  }
}
