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

  func requestToken(socialType: SocialType) {
    var token: String = ""

    switch socialType {
    case .kakao:
      self.loginWithKakao(completionHandler: { accessToken in

        token = accessToken

        let parameters = [
          "socialUuid": token,
          "socialType": socialType.rawValue
        ]

        KKNetworkManager
          .shared
          .request(
            object: LoginResponse.self,
            router: KKRouter.socialLogin(loginInfo: parameters),
            success: { response in
              print(response)
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
