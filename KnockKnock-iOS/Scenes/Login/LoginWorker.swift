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
  func saveToken(authInfo: AuthInfo)
}

final class LoginWorker: LoginWorkerProtocol {
  private let kakaoAccountManager: AccountManagerProtocol
  private let localDataManager: LocalDataManagerProtocol

  init(
    kakaoAccountManager: AccountManagerProtocol,
    localDataManager: LocalDataManagerProtocol
  ) {
    self.kakaoAccountManager = kakaoAccountManager
    self.localDataManager = localDataManager
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

  func saveToken(authInfo: AuthInfo) {
    self.localDataManager.saveToken(
      accessToken: authInfo.accessToken,
      refreshToken: authInfo.refreshToken,
      nickname: nil
    )
  }
}
