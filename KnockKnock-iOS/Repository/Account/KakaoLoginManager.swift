//
//  KakaoAccountManager.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/12/23.
//

import Foundation

import KakaoSDKUser

protocol KakaoLoginManagerProtocol {
  func loginWithKakao(completionHandler: @escaping (String) -> Void)
}

final class KakaoLoginManager: KakaoLoginManagerProtocol {

  func loginWithKakao(completionHandler: @escaping (String) -> Void) {
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk(completion: { (oauthToken, error) in
        if let error = error {
          print(error)
        } else {
          if let oauthToken = oauthToken {
            completionHandler(oauthToken.accessToken)
          }
        }
      })
    } else {
      UserApi.shared.loginWithKakaoAccount(completion: { (oauthToken, error) in
        if let error = error {
          print(error)
        } else {
          if let oauthToken = oauthToken {
            completionHandler(oauthToken.accessToken)
          }
        }
      })
    }
  }
}
