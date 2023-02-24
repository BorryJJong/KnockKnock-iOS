//
//  UserDetail.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/26.
//

import Foundation

import KKDSKit

struct UserDetailDTO: Decodable {
  let nickname: String
  let socialType: String
  let image: String?
}

struct UserDetail {
  let nickname: String
  let socialType: String
  let image: Data?
}

extension UserDetailDTO {

  func toDomain() async -> UserDetail {

    return UserDetail(
      nickname: nickname,
      socialType: socialType,
      image: await image?.getDataFromStringUrl()
    )
  }
}
