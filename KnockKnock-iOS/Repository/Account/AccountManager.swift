//
//  AccountManager.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import UIKit

protocol AccountManagerProtocol {
  func signIn(
    accessToken: String?,
    socialType: SocialType,
    completionHandler: @escaping (AccountResponse, SignInInfo) -> Void
  )
  func register(registerInfo: RegisterInfo, completionHandler: @escaping (AccountResponse) -> Void)
  func signOut(completionHandler: @escaping (Bool) -> Void)
  func withdraw(completionHandler: @escaping (Bool) -> Void)
}

final class AccountManager: AccountManagerProtocol {

  /// 회원가입
  func register(
    registerInfo: RegisterInfo,
    completionHandler: @escaping (AccountResponse) -> Void
  ) {

    KKNetworkManager
      .shared
      .upload(
        object: ApiResponseDTO<AccountResponse>.self,
        router: KKRouter.postSignUp(userInfo: registerInfo),
        success: { response in
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data)
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

    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<AccountResponse>.self,
        router: KKRouter.postSocialLogin(
          socialUuid: accessToken,
          socialType: socialType.rawValue
        ),
        success: { response in
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data, signInInfo)
        },
        failure: { error in
          print(error)
        }
      )
  }

  /// 로그아웃
  func signOut(completionHandler: @escaping (Bool) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<Bool>.self,
        router: KKRouter.postLogOut,
        success: { response in
          if response.message == "SUCCESS" {
            completionHandler(true)
          } else {
            // error
          }
        }, failure: { error in
          print(error)
        }
      )
  }

  /// 회원탈퇴
  func withdraw(completionHandler: @escaping (Bool) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<Bool>.self,
        router: KKRouter.deleteWithdraw,
        success: { response in
          if response.message == "SUCCESS" {
            completionHandler(true)
          } else {
            // error
          }
        }, failure: { error in
          print(error)
        }
      )
  }
}
