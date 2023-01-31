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
  
  func saveUserInfo(response: AccountResponse)
}

protocol AppleLoginDelegate: AnyObject {
  func success(token: String)
}

final class LoginWorker: LoginWorkerProtocol {

  weak var appleLoginResultDelegate: AppleLoginResultDelegate?

  private let kakaoLoginManager: KakaoLoginManagerProtocol
  private let appleLoginManager: AppleLoginManagerProtocol
  private let accountManager: AccountManagerProtocol
  private let userDataManager: UserDataManagerProtocol

  init(
    kakaoLoginManager: KakaoLoginManagerProtocol,
    appleLoginManager: AppleLoginManagerProtocol,
    accountManager: AccountManagerProtocol,
    userDataManager: UserDataManagerProtocol
  ) {
    self.kakaoLoginManager = kakaoLoginManager
    self.appleLoginManager = appleLoginManager
    self.accountManager = accountManager
    self.userDataManager = userDataManager
  }

  /// 로그인 api response 받아오기
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

  /// - Parameters:
  ///   - response: 회원가입/로그인 api response(userinfo)
  func saveUserInfo(response: AccountResponse) {
    self.userDataManager.saveUserInfo(response: response)
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
