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
  private let snsLoginAccountManager: SNSLoginAccountManagerProtocol
  private let localDataManager: LocalDataManagerProtocol

  init(
    snsLoginAccountManager: SNSLoginAccountManagerProtocol,
    localDataManager: LocalDataManagerProtocol
  ) {
    self.snsLoginAccountManager = snsLoginAccountManager
    self.localDataManager = localDataManager
  }

  func requestSignUp(
    loginInfo: LoginInfo,
    nickname: String,
    image: String,
    completionHandler: @escaping (SignUpResponse) -> Void
  ) {
    self.snsLoginAccountManager.signUp(
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
