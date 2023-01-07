//
//  AccountManager.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import Foundation

protocol AccountManagerProtocol {
  func signIn(
    accessToken: String?,
    socialType: SocialType,
    completionHandler: @escaping (AccountResponse, SignInInfo) -> Void
  )
  func register(
    signInInfo: SignInInfo,
    nickname: String,
    image: String,
    completionHandler: @escaping (AccountResponse) -> Void
  )
  func signOut(completionHanlder: @escaping (Bool) -> Void)
  func withdraw(completionHanlder: @escaping (Bool) -> Void)
}

final class AccountManager: AccountManagerProtocol {

  /// 회원가입
  func register(
    signInInfo: SignInInfo,
    nickname: String,
    image: String,
    completionHandler: @escaping (AccountResponse) -> Void
  ) {
    let parameters = [
      "socialUuid": signInInfo.socialUuid,
      "socialType": signInInfo.socialType,
      "nickname": nickname,
      "image": image
    ]

    KKNetworkManager
      .shared
      .request(
        object: AccountResponse.self,
        router: KKRouter.postSignUp(userInfo: parameters),
        success: { success in
          completionHandler(success)
        }, failure: { error in
          print(error)
        }
      )
  }

  /// 로그인
  func signIn(
    accessToken: String? = nil,
    socialType: SocialType,
    completionHandler: @escaping (AccountResponse, SignInInfo) -> Void
  ) {

      guard let accessToken = accessToken else { return }

      let signInInfo = SignInInfo(
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
          object: AccountResponse.self,
          router: KKRouter.postSocialLogin(signInInfo: parameters),
          success: { response in
            completionHandler(response, signInInfo)
          },
          failure: { error in
            print(error)
          }
        )
  }

  /// 로그아웃
  func signOut(completionHanlder: @escaping (Bool) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: Bool.self,
        router: KKRouter.postLogOut,
        success: { response in
          print(response)
          completionHanlder(response)
        }, failure: { error in
          print(error)
        }
      )
  }

  /// 회원탈퇴
  func withdraw(completionHanlder: @escaping (Bool) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: Bool.self,
        router: KKRouter.deleteWithdraw,
        success: { response in
          completionHanlder(response)
        }, failure: { error in
          print(error)
        }
      )
  }
}
