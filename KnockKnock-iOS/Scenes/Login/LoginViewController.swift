//
//  LoginViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/06.
//

import UIKit

import Then

protocol LoginViewProtocol: AnyObject {
  var interactor: LoginInteractorProtocol? { get set }
}

final class LoginViewController: BaseViewController<LoginView> {

  var interactor: LoginInteractorProtocol?

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

    self.containerView.logoutButton.addTarget(
      self,
      action: #selector(self.logoutButtonDidTap(_:)),
      for: .touchUpInside
    )
  }

  // MARK: - Button Actions

  @objc func kakaoLoginButtonDidTap(_ sender: UIButton) {
    self.interactor?.fetchLoginResult(source: self, socialType: SocialType.kakao)
  }

  // 테스트를 위한 임시 로그아웃 버튼
  @objc func logoutButtonDidTap(_ sender: UIButton) {
    LocalDataManager().deleteToken()
  }
}

extension LoginViewController: LoginViewProtocol {

}
