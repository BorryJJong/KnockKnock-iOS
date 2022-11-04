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

  init(accountManager: AccountManagerProtocol) {
    self.accountManager = accountManager
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
      completionHandler: { response in
        print(response)
    })
  }
}
