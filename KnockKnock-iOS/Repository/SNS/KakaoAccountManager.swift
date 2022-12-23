//
//  KakaoAccountManager.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/12/23.
//

import Foundation
import KakaoSDKUser

final class KakaoAccountManager: SocialLoginManagerProtocol {

  // 회원가입

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
        router: KKRouter.postSignUp(userInfo: parameters),
        success: { success in
          completionHandler(success)
        }, failure: { error in
          print(error)
        }
      )
  }

  // 로그인

  func requestToken(
    accessToken: String? = nil,
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
          router: KKRouter.postSocialLogin(loginInfo: parameters),
          success: { response in
            completionHandler(response, loginInfo)
          },
          failure: { error in
            print(error)
          }
        )
    })
  }

  private func loginWithKakao(completionHandler: @escaping (String) -> Void) {
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
