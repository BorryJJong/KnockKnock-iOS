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
  private let userDataManager: UserDataManagerProtocol

  init(
    accountManager: AccountManagerProtocol,
    userDataManager: UserDataManagerProtocol
  ) {
    self.accountManager = accountManager
    self.userDataManager = userDataManager
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

        self.userDataManager.userDefaultsService.set(value: authInfo.accessToken, forkey: .accessToken)
        self.userDataManager.userDefaultsService.set(value: authInfo.refreshToken, forkey: .refreshToken)
      }
    )
  }

  func saveUserInfo(response: AccountResponse) {

    guard let authInfo = response.authInfo else { return }

    if let userInfo = response.userInfo {
      self.userDataManager.userDefaultsService.set(value: userInfo.image, forkey: .profileImage)
      self.userDataManager.userDefaultsService.set(value: userInfo.nickname, forkey: .nickname)
    }

    self.userDataManager.userDefaultsService.set(value: authInfo.accessToken, forkey: .accessToken)
    self.userDataManager.userDefaultsService.set(value: authInfo.refreshToken, forkey: .refreshToken)

  }
}
