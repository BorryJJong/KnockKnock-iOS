//
//  LoginRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import Foundation

import KakaoSDKUser

protocol LoginRepositoryProtocol {
  func requestToken(socialType: SocialType, completionHandler: @escaping (LoginResponse) -> Void)
}

final class LoginRepository: LoginRepositoryProtocol {

  // signUp

  func signUp(socialType: SocialType) {

  }

  // login

  func requestToken(
    socialType: SocialType,
    completionHandler: @escaping (LoginResponse) -> Void
  ) {
    switch socialType {
    case .kakao:
      self.loginWithKakao(completionHandler: { accessToken in

        let parameters = [
          "socialUuid": "sUhGzYLIvkRbD2pCy2sxLqG2-eNPVXf-lL43w6U4CilwngAAAYQytWtw",
          "socialType": socialType.rawValue
        ]

        KKNetworkManager
          .shared
          .request(
            object: LoginResponse.self,
            router: KKRouter.socialLogin(loginInfo: parameters),
            success: { response in
              completionHandler(response)
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
    // 웹으로 로그인 -> 앱으로 로그인 변경 필요
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
