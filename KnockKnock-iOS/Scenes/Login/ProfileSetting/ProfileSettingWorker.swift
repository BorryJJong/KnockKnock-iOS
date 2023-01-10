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
  func saveUserInfo(response: AccountResponse)
}

final class ProfileSettingWorker: ProfileSettingWorkerProtocol {
  private let accountManager: AccountManagerProtocol
  private let localDataManager: UserDataManagerProtocol

  init(
    accountManager: AccountManagerProtocol,
    localDataManager: UserDataManagerProtocol
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

        self.localDataManager.userDefaultsService.set(value: authInfo.accessToken, forkey: .accessToken)
        self.localDataManager.userDefaultsService.set(value: authInfo.refreshToken, forkey: .refreshToken)
      }
    )
  }

  func saveUserInfo(response: AccountResponse) {

    guard let authInfo = response.authInfo else { return }

    if let userInfo = response.userInfo {
      self.localDataManager.userDefaultsService.set(value: userInfo.image, forkey: .profileImage)
      self.localDataManager.userDefaultsService.set(value: userInfo.nickname, forkey: .nickname)
    }

    self.localDataManager.userDefaultsService.set(value: authInfo.accessToken, forkey: .accessToken)
    self.localDataManager.userDefaultsService.set(value: authInfo.refreshToken, forkey: .refreshToken)

  }
}
