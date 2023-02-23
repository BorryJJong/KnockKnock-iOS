//
//  UserDetail.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/26.
//

import UIKit

import KKDSKit

struct UserDetailDTO: Decodable {
  let nickname: String
  let socialType: String
  let image: String?
}

struct UserDetail {
  let nickname: String
  let socialType: String
  let image: UIImage
}

extension UserDetailDTO {

  func toDomain() async -> UserDetail {

    return UserDetail(
      nickname: nickname,
      socialType: socialType,
      image: await image?.getImageFromStringUrl(
        defaultImage: KKDS.Image.ic_my_img_86,
        imageWidth: 86
      ) ?? KKDS.Image.ic_my_img_86
    )
  }
}
