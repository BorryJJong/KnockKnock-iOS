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
  private let kakaoAccountManager: AccountManagerProtocol

  init(kakaoAccountManager: AccountManagerProtocol) {
    self.kakaoAccountManager = kakaoAccountManager
  }

  func fetchLoginResult(
    socialType: SocialType,
    completionHandler: @escaping (LoginResponse, LoginInfo) -> Void
  ) {
    switch socialType {
    case .kakao:
      self.kakaoAccountManager.requestToken(
        completionHandler: { loginResponse, loginInfo in
        completionHandler(loginResponse, loginInfo)
      })
    case .apple:
      print("apple")
    }
  }
}
