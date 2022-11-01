//
//  LoginRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import Foundation

import KakaoSDKUser

protocol LoginRepositoryProtocol {
  func loginWithKakao()
}

final class LoginRepository {
  func loginWithKakao() {
    // 웹으로 로그인 -> 앱으로 로그인 변경 필요
    UserApi.shared.loginWithKakaoAccount(completion: { (oauthToken, error) in
      if let error = error {
        print(error)
      } else {
        print(oauthToken)
      }
    })
  }
}
