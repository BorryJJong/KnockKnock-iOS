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

struct SignUpResponse: Decodable {
  let isExistUser: Bool
  let authInfo: AuthInfo?
}

struct LoginResponse: Decodable {
  let isExistUser: Bool
  let authInfo: AuthInfo?
}

struct AuthInfo: Decodable {
  let accessToken: String
  let refreashToken: String
}
