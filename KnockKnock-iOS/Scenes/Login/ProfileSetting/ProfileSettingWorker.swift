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
  private let accountManager: AccountManagerProtocol
  private let localDataManager: LocalDataManagerProtocol

  init(
    accountManager: AccountManagerProtocol,
    localDataManager: LocalDataManagerProtocol
  ) {
    self.accountManager = accountManager
    self.localDataManager = localDataManager
  }

  func requestSignUp(
    loginInfo: LoginInfo,
    nickname: String,
    image: String,
    completionHandler: @escaping (SignUpResponse) -> Void
  ) {
    self.accountManager.signUp(
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
