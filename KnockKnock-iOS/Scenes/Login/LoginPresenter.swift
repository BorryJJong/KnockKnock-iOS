//
//  LoginPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import UIKit

protocol LoginPresenterProtocol {
  var view: LoginViewProtocol? { get set }

  func presentLoginResult(loginResult: LoginResponse, loginInfo: LoginInfo)
}

final class LoginPresenter: LoginPresenterProtocol {
  weak var view: LoginViewProtocol?

  func presentLoginResult(
    loginResult: LoginResponse,
    loginInfo: LoginInfo
  ) {
    self.view?.fetchLoginResult(
      loginResult: loginResult,
      loginInfo: loginInfo
    )
  }
}
