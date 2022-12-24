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

protocol AppleLoginDelegate: AnyObject {
  func success(token: String)
}

extension LoginWorker: AppleLoginDelegate {
  
  func success(token: String) {
    self.snsLoginAccountManager.requestToken(accessToken: token) { response, loginInfo in
      print("성공여부 : \(response.isExistUser)")
      }
  }
}

final class LoginWorker: LoginWorkerProtocol {
  
  private let kakaoAccountManager: SocialLoginManagerProtocol
  private let appleAccountManager: AppleLoginRepository
  private let snsLoginAccountManager: SNSLoginAccountManager
  private let localDataManager: LocalDataManagerProtocol

  init(
    kakaoAccountManager: SocialLoginManagerProtocol,
    appleAccountManager: AppleLoginRepository,
    snsLoginAccountManager: SNSLoginAccountManager,
    localDataManager: LocalDataManagerProtocol
  ) {
    self.kakaoAccountManager = kakaoAccountManager
    self.appleAccountManager = appleAccountManager
    self.snsLoginAccountManager = snsLoginAccountManager
    self.localDataManager = localDataManager
  }

  func fetchLoginResult(
    socialType: SocialType,
    completionHandler: @escaping (LoginResponse, LoginInfo) -> Void
  ) {
    switch socialType {
    case .kakao:
      self.kakaoAccountManager.requestToken(
        accessToken: nil,
        completionHandler: { loginResponse, loginInfo in
          completionHandler(loginResponse, loginInfo)
        }
      )
    case .apple:
      self.appleAccountManager.login(delegate: self)
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
