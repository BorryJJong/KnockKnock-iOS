//
//  LoginWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import UIKit

protocol LoginWorkerProtocol {
  func fetchLoginResult(
    appleLoginResultDelegate: AppleLoginResultDelegate,
    socialType: SocialType,
    completionHandler: @escaping (LoginResponse, LoginInfo) -> Void
  )
  
  func saveUserInfo(
    userInfo: LoginResponse.UserInfo,
    authInfo: AuthInfo
  )
}

protocol AppleLoginDelegate: AnyObject {
  func success(token: String)
}

final class LoginWorker: LoginWorkerProtocol {

  weak var appleLoginResultDelegate: AppleLoginResultDelegate?

  private let kakaoLoginManager: KakaoLoginManagerProtocol
  private let appleLoginManager: AppleLoginManagerProtocol
  private let accountManager: AccountManagerProtocol
  private let localDataManager: LocalDataManagerProtocol

  init(
    kakaoLoginManager: KakaoLoginManagerProtocol,
    appleLoginManager: AppleLoginManagerProtocol,
    accountManager: AccountManagerProtocol,
    localDataManager: LocalDataManagerProtocol
  ) {
    self.kakaoLoginManager = kakaoLoginManager
    self.appleLoginManager = appleLoginManager
    self.accountManager = accountManager
    self.localDataManager = localDataManager
  }

  func fetchLoginResult(
    appleLoginResultDelegate: AppleLoginResultDelegate,
    socialType: SocialType,
    completionHandler: @escaping (LoginResponse, LoginInfo) -> Void
  ) {
    switch socialType {
    case .kakao:
      self.kakaoLoginManager.loginWithKakao(completionHandler: { accessToken in

        self.accountManager.logIn(
          accessToken: accessToken,
          socialType: socialType,
          completionHandler: { loginResponse, loginInfo in
            completionHandler(loginResponse, loginInfo)
          }
        )
      })

    case .apple:
      self.appleLoginResultDelegate = appleLoginResultDelegate
      self.appleLoginManager.requestAppleLogin(delegate: self)
    }
  }

  func saveUserInfo(
    userInfo: LoginResponse.UserInfo,
    authInfo: AuthInfo
  ) {

    self.localDataManager.saveToken(
      accessToken: authInfo.accessToken,
      refreshToken: authInfo.refreshToken,
      nickname: userInfo.nickname,
      profileImage: userInfo.image
    )
  }
}

// MARK: - Apple login delegate

extension LoginWorker: AppleLoginDelegate {

  func success(token: String) {
    self.accountManager.logIn(
      accessToken: token,
      socialType: SocialType.apple
    ) { response, loginInfo in

      self.appleLoginResultDelegate?.getLoginResult(
        loginResponse: response,
        loginInfo: loginInfo
      )
    }
  }
}
