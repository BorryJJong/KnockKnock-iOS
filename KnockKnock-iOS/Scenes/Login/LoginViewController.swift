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
      source: self,
      socialType: SocialType.kakao
    )
  }

  @objc func appleLoginButtonDidTap(_ sender: UIButton) {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
    authorizationController.performRequests()
  }

  @objc func tapCloseBarButtonDidTap(_ sender: UIButton) {
    self.interactor?.popLoginView(source: self)
  }
}

extension LoginViewController: LoginViewProtocol, ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
      let user = credential.user
      print("👨‍🍳 \(user)")
      if let email = credential.email {
        print("✉️ \(email)")
      }
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      print("error \(error)")
  }
}
