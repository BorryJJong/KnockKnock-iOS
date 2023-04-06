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
    completionHandler: @escaping (ApiResponse<Account>?, SignInInfo) -> Void
  )
  func register(
    registerInfo: RegisterInfo,
    completionHandler: @escaping (ApiResponse<Account>?) -> Void
  )
  func signOut(completionHandler: @escaping (ApiResponse<Bool>?) -> Void)
  func withdraw(completionHandler: @escaping (ApiResponse<Bool>?) -> Void)
}

final class AccountManager: AccountManagerProtocol {

  /// 회원가입
  func register(
    registerInfo: RegisterInfo,
    completionHandler: @escaping (ApiResponse<Account>?) -> Void
  ) {
    
    KKNetworkManager
      .shared
      .upload(
        object: ApiResponse<AccountDTO>.self,
        router: KKRouter.postSignUp(userInfo: registerInfo),
        success: { response in
          
          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.toDomain()
          )
          completionHandler(result)
          
        }, failure: { response, error in
          
          guard let response = response else {
            completionHandler(nil)
            return
          }
          
          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.toDomain()
          )
          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }

  /// 로그인
  func signIn(
    accessToken: String? = nil,
    socialType: SocialType,
    completionHandler: @escaping (ApiResponse<Account>?, SignInInfo) -> Void
  ) {

    guard let accessToken = accessToken else { return }

    let signInInfo = SignInInfo(
      socialUuid: accessToken,
      socialType: socialType.rawValue
    )

    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<AccountDTO>.self,
        router: KKRouter.postSocialLogin(
          socialUuid: accessToken,
          socialType: socialType.rawValue
        ),
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.toDomain()
          )
          completionHandler(result, signInInfo)
        },
        failure: { response, error in

          guard let response = response else {
            completionHandler(nil, signInInfo)
            return
          }

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.toDomain()
          )
          completionHandler(result, signInInfo)
          print(error.localizedDescription)
        }
      )
  }

  /// 로그아웃
  func signOut(
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<Bool>.self,
        router: KKRouter.postLogOut,
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.code == 200
          )
          completionHandler(result)

        }, failure: { response, error in

          guard let response = response else {
            completionHandler(nil)
            return
          }

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.code == 200
          )
          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }

  /// 회원탈퇴
  func withdraw(
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<Bool>.self,
        router: KKRouter.deleteWithdraw,
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.code == 200
          )
          completionHandler(result)

        }, failure: { response, error in

          guard let response = response else {
            completionHandler(nil)
            return
          }

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.code == 200
          )
          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }
}
