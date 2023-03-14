//
//  User.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import Foundation

/// 로그인 요청시 request body에 사용
struct SignInInfo {
  let socialUuid: String
  let socialType: String
}

/// 회원가입 요청
struct RegisterInfo {
  let socialUuid: String
  let socialType: String
  let nickname: String
  let image: Data?
}

/// 로그인/회원가입 응답 값
struct Account: Decodable {
  let isExistUser: Bool
  let userInfo: UserInfo?
  let authInfo: AuthInfo?

  struct UserInfo: Decodable {
    let nickname: String
    let socialType: String?
    let image: String?
  }

  struct AuthInfo: Decodable {
    let accessToken: String
    let refreshToken: String
  }
}

struct AccountDTO: Decodable {
  let isExistUser: Bool
  let userInfo: UserInfo?
  let authInfo: AuthInfo?

  struct UserInfo: Decodable {
    let nickname: String
    let socialType: String?
    let image: String?
  }

  struct AuthInfo: Decodable {
    let accessToken: String
    let refreshToken: String
  }
}

extension AccountDTO {
  func toDomain() -> Account {

    guard let userInfo = userInfo,
          let authInfo = authInfo else {

      return .init(
        isExistUser: isExistUser,
        userInfo: nil,
        authInfo: nil
      )
    }

    return .init(
      isExistUser: isExistUser,
      userInfo: Account.UserInfo(
        nickname: userInfo.nickname,
        socialType: userInfo.socialType,
        image: userInfo.image
      ), authInfo: Account.AuthInfo(
        accessToken: authInfo.accessToken,
        refreshToken: authInfo.refreshToken
      )
    )
  }
}
