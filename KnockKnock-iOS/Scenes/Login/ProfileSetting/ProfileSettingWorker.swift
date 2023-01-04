//
//  ProfileSettingWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/03.
//

import UIKit

protocol ProfileSettingWorkerProtocol {
  func requestRegister(
    signInInfo: SignInInfo,
    nickname: String,
    image: String,
    completionHandler: @escaping (AccountResponse) -> Void
  )
  func saveUserInfo(accountInfo: AccountResponse)
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

  func requestRegister(
    signInInfo: SignInInfo,
    nickname: String,
    image: String,
    completionHandler: @escaping (AccountResponse) -> Void
  ) {
    
    self.accountManager.register(
      signInInfo: signInInfo,
      nickname: nickname,
      image: image,
      completionHandler: { response in
        guard let authInfo = response.authInfo else { return }

        self.localDataManager.saveToken(
          accessToken: authInfo.accessToken,
          refreshToken: authInfo.refreshToken,
          nickname: nickname,
          profileImage: image
        )
      }
    )
  }

  func saveUserInfo(accountInfo: AccountResponse) {

    guard let userInfo = accountInfo.userInfo,
          let authInfo = accountInfo.authInfo else { return }

    self.localDataManager.saveToken(
      accessToken: authInfo.accessToken,
      refreshToken: authInfo.refreshToken,
      nickname: userInfo.nickname,
      profileImage: userInfo.image
    )
  }
}
