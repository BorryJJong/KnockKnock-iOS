//
//  ProfileSettingWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/03.
//

import UIKit

protocol ProfileSettingWorkerProtocol {
  func requestSignUp(
    loginInfo: LoginInfo,
    nickname: String,
    image: String,
    completionHandler: @escaping (SignUpResponse) -> Void
  )
}

final class ProfileSettingWorker: ProfileSettingWorkerProtocol {
  private let kakaoAccountManager: SocialLoginManagerProtocol
  private let localDataManager: LocalDataManagerProtocol

  init(
    kakaoAccountManager: SocialLoginManagerProtocol,
    localDataManager: LocalDataManagerProtocol
  ) {
    self.kakaoAccountManager = kakaoAccountManager
    self.localDataManager = localDataManager
  }

  func requestSignUp(
    loginInfo: LoginInfo,
    nickname: String,
    image: String,
    completionHandler: @escaping (SignUpResponse) -> Void
  ) {
    self.kakaoAccountManager.signUp(
      loginInfo: loginInfo,
      nickname: nickname,
      image: image,
      completionHandler: { signUpResponse in
        if let authInfo = signUpResponse.authInfo {
          self.localDataManager.saveToken(
            accessToken: authInfo.accessToken,
            refreshToken: authInfo.refreshToken,
            nickname: nickname
          )
        }
    })
  }
}
