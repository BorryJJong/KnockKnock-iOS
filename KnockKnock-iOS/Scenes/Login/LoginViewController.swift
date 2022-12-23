//
//  LoginViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/06.
//

import UIKit

import Then
import KKDSKit

import AuthenticationServices

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

    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: KKDS.Image.ic_close_24_bk,
      style: .plain,
      target: self,
      action: #selector(tapCloseBarButtonDidTap(_:))
    ).then {
      $0.tintColor = .black
    }

    self.containerView.kakaoLoginButton.addTarget(
      self,
      action: #selector(self.kakaoLoginButtonDidTap(_:)),
      for: .touchUpInside
    )

    self.containerView.appleLoginButton.addTarget(
      self,
      action: #selector(self.appleLoginButtonDidTap(_:)),
      for: .touchUpInside
    )
  }

  // MARK: - Button Actions

  @objc func kakaoLoginButtonDidTap(_ sender: UIButton) {
    self.interactor?.fetchLoginResult(
      accessToken: nil,
      source: self,
      socialType: SocialType.kakao
    )
  }

  @objc func appleLoginButtonDidTap(_ sender: UIButton) {
    self.interactor?.fetchLoginResult(
      accessToken: nil,
      source: self,
      socialType: SocialType.apple
    )
  }

  @objc func tapCloseBarButtonDidTap(_ sender: UIButton) {
    self.interactor?.popLoginView(source: self)
  }
}

extension LoginViewController: LoginViewProtocol {

}

extension LoginViewController: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      if  let authorizationCode = appleIDCredential.authorizationCode,
          let identityToken = appleIDCredential.identityToken,
          let authString = String(data: authorizationCode, encoding: .utf8),
          let tokenString = String(data: identityToken, encoding: .utf8) {

        self.interactor?.fetchLoginResult(accessToken: tokenString, source: self, socialType: .apple)
      }

    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print("error \(error)")
  }
}
