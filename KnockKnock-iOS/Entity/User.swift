//
//  User.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import Foundation

struct LoginInfo {
  let socialUuid: String
  let socialType: String
}

struct SignUpInfo {
  let socialUuid: String
  let socialType: String
  let nickname: String
  let image: String
}

struct LoginResponse: Decodable {
  let isExistUser: Bool
  let authInfo: AuthInfo?
}

struct AuthInfo: Decodable {
  let accessToken: String
  let refreashToken: String
}
