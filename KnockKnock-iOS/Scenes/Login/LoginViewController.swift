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

  func showAlertView(
    message: String,
    isCancelActive: Bool,
    confirmAction: (() -> Void)?
  )
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
    self.interactor?.fetchLoginResult(socialType: SocialType.kakao)
  }

  @objc func appleLoginButtonDidTap(_ sender: UIButton) {
    self.interactor?.fetchLoginResult(socialType: SocialType.apple)
  }

  @objc func tapCloseBarButtonDidTap(_ sender: UIButton) {
    self.interactor?.popLoginView()
  }
}

extension LoginViewController: LoginViewProtocol, AlertProtocol {

  /// Alert 팝업 창
  func showAlertView(
    message: String,
    isCancelActive: Bool,
    confirmAction: (() -> Void)?
  ) {
    self.showAlert(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}
