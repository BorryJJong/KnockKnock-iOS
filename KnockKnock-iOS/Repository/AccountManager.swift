//
//  AccountManager.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import Foundation

import KakaoSDKUser

protocol AccountManagerProtocol {
  func requestToken(
    socialType: SocialType,
    completionHandler: @escaping (LoginResponse, LoginInfo) -> Void
  )
  func signUp(
    loginInfo: LoginInfo,
    nickname: String,
    image: String,
    completionHandler: @escaping (SignUpResponse) -> Void
  )
}

final class AccountManager: AccountManagerProtocol {

  // signUp

  func signUp(
    loginInfo: LoginInfo,
    nickname: String,
    image: String,
    completionHandler: @escaping (SignUpResponse) -> Void
  ) {

    let parameters = [
      "socialUuid": loginInfo.socialUuid,
      "socialType": loginInfo.socialType,
      "nickname": nickname,
      "image": image
    ]

    KKNetworkManager
      .shared
      .request(
        object: SignUpResponse.self,
        router: KKRouter.signUp(userInfo: parameters),
        success: { success in
          completionHandler(success)
        }, failure: { error in
          print(error)
        }
      )
  }

  // login

  func requestToken(
    socialType: SocialType,
    completionHandler: @escaping (LoginResponse, LoginInfo) -> Void
  ) {
    switch socialType {
    case .kakao:
      self.loginWithKakao(completionHandler: { accessToken in

        let loginInfo = LoginInfo(
          socialUuid: accessToken,
          socialType: socialType.rawValue
        )

        let parameters = [
          "socialUuid": accessToken,
          "socialType": socialType.rawValue
        ]

        KKNetworkManager
          .shared
          .request(
            object: LoginResponse.self,
            router: KKRouter.socialLogin(loginInfo: parameters),
            success: { response in
              completionHandler(response, loginInfo)
            },
            failure: { error in
              print(error)
            }
          )
      })
    case .apple:
      print("Apple")
    }
  }

  func loginWithKakao(completionHandler: @escaping (String) -> Void) {
    // 추후에 웹으로 로그인 -> 앱으로 로그인 변경 필요
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
