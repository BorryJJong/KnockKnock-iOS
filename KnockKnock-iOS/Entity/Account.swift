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

/// 로그인/회원가입 응답 값
struct AccountResponse: Decodable {
  let isExistUser: Bool
  let userInfo: UserInfo?
  let authInfo: AuthInfo?

  struct UserInfo: Decodable {
    let nickname: String
    let soicalType: String?
    let image: String?
  }

  struct AuthInfo: Decodable {
    let accessToken: String
    let refreshToken: String
  }
}

