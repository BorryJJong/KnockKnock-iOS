//
//  LoginViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/06.
//

import UIKit

import Then
import KKDSKit

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
  }

  // MARK: - Button Actions

  @objc func kakaoLoginButtonDidTap(_ sender: UIButton) {
    self.interactor?.fetchLoginResult(
      source: self,
      socialType: SocialType.kakao
    )
  }

  @objc func tapCloseBarButtonDidTap(_ sender: UIButton) {
    self.interactor?.popLoginView(source: self)
  }
}

extension LoginViewController: LoginViewProtocol {

}

