//
//  LoginWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import UIKit

protocol LoginWorkerProtocol {
  func fetchSignInResult(
    appleLoginResultDelegate: AppleLoginResultDelegate,
    socialType: SocialType,
    completionHandler: @escaping (AccountResponse, SignInInfo) -> Void
  )
  
  func saveUserInfo(
    userInfo: AccountResponse.UserInfo,
    authInfo: AccountResponse.AuthInfo
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

  func fetchSignInResult(
    appleLoginResultDelegate: AppleLoginResultDelegate,
    socialType: SocialType,
    completionHandler: @escaping (AccountResponse, SignInInfo) -> Void
  ) {
    switch socialType {
    case .kakao:
      self.kakaoLoginManager.excute(completionHandler: { accessToken in

        self.accountManager.signIn(
          accessToken: accessToken,
          socialType: socialType,
          completionHandler: { response, loginInfo in
            completionHandler(response, loginInfo)
          }
        )
      })

    case .apple:
      self.appleLoginResultDelegate = appleLoginResultDelegate
      self.appleLoginManager.excute(delegate: self)
    }
  }

  func saveUserInfo(
    userInfo: AccountResponse.UserInfo,
    authInfo: AccountResponse.AuthInfo
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
    self.accountManager.signIn(
      accessToken: token,
      socialType: SocialType.apple
    ) { response, signInInfo in

      self.appleLoginResultDelegate?.getSignInResult(
        response: response,
        signInInfo: signInInfo
      )
    }
  }
}
