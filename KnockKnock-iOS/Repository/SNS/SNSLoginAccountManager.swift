//
//  SNSLoginAccountManager.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/12/23.
//

import Foundation

protocol SNSLoginAccountManagerProtocol {
  func requestToken(
    accessToken: String?,
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

final class SNSLoginAccountManager: SNSLoginAccountManagerProtocol {
  
  /// 회원가입
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
    socialType: SocialType,
    completionHandler: @escaping (LoginResponse, LoginInfo) -> Void
  ) {

      guard let accessToken = accessToken else { return }

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
          router: KKRouter.postSocialLogin(loginInfo: parameters),
          success: { response in
            completionHandler(response, loginInfo)
          },
          failure: { error in
            print(error)
          }
        )
  }
}
