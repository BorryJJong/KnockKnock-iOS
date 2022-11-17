//
//  LoginInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import UIKit

protocol LoginInteractorProtocol {
  var presenter: LoginPresenterProtocol? { get set }
  var worker: LoginWorkerProtocol? { get set }

  func fetchLoginResult(socialType: SocialType)
  func saveTokens(loginResponse: LoginResponse)
}

final class LoginInteractor: LoginInteractorProtocol {

  var presenter: LoginPresenterProtocol?
  var worker: LoginWorkerProtocol?

  func fetchLoginResult(
    socialType: SocialType
  ) {
    self.worker?.fetchLoginResult(
      socialType: socialType,
      completionHandler: { loginResponse, loginInfo in
        self.presenter?.presentLoginResult(
          loginResponse: loginResponse,
          loginInfo: loginInfo
        )
    })
  }

  func saveTokens(loginResponse: LoginResponse) {
    if let authInfo = loginResponse.authInfo{
      self.worker?.saveToken(authInfo: authInfo)
    }
  }
}
