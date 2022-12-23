//
//  AccountManager.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import Foundation

protocol SocialLoginManagerProtocol {
  func requestToken(
    accessToken: String?,
    completionHandler: @escaping (LoginResponse, LoginInfo) -> Void
  )
  func signUp(
    loginInfo: LoginInfo,
    nickname: String,
    image: String,
    completionHandler: @escaping (SignUpResponse) -> Void
  )

}

protocol AccountManagerProtocol {
  func logOut(completionHanlder: @escaping (Bool) -> Void)
  func signOut(completionHanlder: @escaping (Bool) -> Void)
}

final class AccountManager: AccountManagerProtocol {

  // 로그아웃

  func logOut(completionHanlder: @escaping (Bool) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: Bool.self,
        router: KKRouter.postLogOut,
        success: { response in
          completionHanlder(response)
        }, failure: { error in
          print(error)
        }
      )
  }

  // 회원탈퇴

  func signOut(completionHanlder: @escaping (Bool) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: Bool.self,
        router: KKRouter.deleteSignOut,
        success: { response in
          completionHanlder(response)
        }, failure: { error in
          print(error)
        }
      )
  }
}
