//
//  LoginWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import UIKit

protocol LoginWorkerProtocol {
  func fetchLoginResult(
    socialType: SocialType,
    completionHandler: @escaping (LoginResponse, LoginInfo) -> Void
  )
}

final class LoginWorker: LoginWorkerProtocol {
  private let accountManager: AccountManagerProtocol

  init(accountManager: AccountManagerProtocol) {
    self.accountManager = accountManager
  }

  func fetchLoginResult(
    socialType: SocialType,
    completionHandler: @escaping (LoginResponse, LoginInfo) -> Void
  ) {
    self.accountManager.requestToken(
      socialType: socialType,
      completionHandler: { loginResponse, loginInfo in
      completionHandler(loginResponse, loginInfo)
    })
  }
}
