//
//  User.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import Foundation

/// login 요청시 request body에 사용
struct LoginInfo {
  let socialUuid: String
  let socialType: String
}

/// 회원가입 응답 값
struct SignUpResponse: Decodable {
  let isExistUser: Bool
  let authInfo: AuthInfo?
}

/// 로그인 응답 값
struct LoginResponse: Decodable {
  let isExistUser: Bool
  let userInfo: UserInfo?
  let authInfo: AuthInfo?

  struct UserInfo: Decodable {
    let nickname: String
    let soicalType: String?
    let image: String?
  }
}

/// 토큰
struct AuthInfo: Decodable {
  let accessToken: String
  let refreshToken: String
}
