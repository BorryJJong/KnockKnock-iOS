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
  private let kakaoAccountManager: AccountManagerProtocol

  init(kakaoAccountManager: AccountManagerProtocol) {
    self.kakaoAccountManager = kakaoAccountManager
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
          UserDefaults.standard.set(authInfo.accessToken, forKey: "accessToken")
          UserDefaults.standard.set(authInfo.refreshToken, forKey: "refreshToken")
          UserDefaults.standard.set(nickname, forKey: "nickname")
        }
    })
  }
}
