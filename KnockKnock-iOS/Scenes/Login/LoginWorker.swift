//
//  LoginWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import UIKit

protocol LoginWorkerProtocol {
  func fetchLoginResult(
    accessToken: String?,
    socialType: SocialType,
    completionHandler: @escaping (LoginResponse, LoginInfo) -> Void
  )
  func saveToken(authInfo: AuthInfo)
}

final class LoginWorker: LoginWorkerProtocol {
  private let kakaoAccountManager: SocialLoginManagerProtocol
  private let appleAccountManager: SocialLoginManagerProtocol
  private let localDataManager: LocalDataManagerProtocol

  init(
    kakaoAccountManager: SocialLoginManagerProtocol,
    appleAccountManager: SocialLoginManagerProtocol,
    localDataManager: LocalDataManagerProtocol
  ) {
    self.kakaoAccountManager = kakaoAccountManager
    self.appleAccountManager = appleAccountManager
    self.localDataManager = localDataManager
  }

  func fetchLoginResult(
    accessToken: String? = nil,
    socialType: SocialType,
    completionHandler: @escaping (LoginResponse, LoginInfo) -> Void
  ) {
    switch socialType {
    case .kakao:
      self.kakaoAccountManager.requestToken(accessToken: nil,
        completionHandler: { loginResponse, loginInfo in
          completionHandler(loginResponse, loginInfo)
        }
      )
    case .apple:
      self.appleAccountManager.requestToken(accessToken: accessToken, completionHandler: { loginResponse, loginInfo in
        completionHandler(loginResponse, loginInfo)
      })
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
