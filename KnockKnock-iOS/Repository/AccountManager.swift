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
    completionHandler: @escaping (LoginResponse, LoginInfo) -> Void
  )
  func signUp(
    loginInfo: LoginInfo,
    nickname: String,
    image: String,
    completionHandler: @escaping (SignUpResponse) -> Void
  )
}

final class KakaoAccountManager: AccountManagerProtocol {

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
    completionHandler: @escaping (LoginResponse, LoginInfo) -> Void
  ) {
      self.loginWithKakao(completionHandler: { accessToken in

        let loginInfo = LoginInfo(
          socialUuid: accessToken,
          socialType: SocialType.kakao.rawValue
        )

        let parameters = [
          "socialUuid": accessToken,
          "socialType": SocialType.kakao.rawValue
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
  }

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
