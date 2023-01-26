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

  func toDomain() -> UserDetail {
    guard let urlString = image,
          let url = URL(string: urlString) else {

      return UserDetail(
        nickname: nickname,
        socialType: socialType,
        image: KKDS.Image.ic_my_img_86
      )
    }

    do {
      let data = try Data(contentsOf: url)
      let image = UIImage(data: data)

      return UserDetail(
        nickname: nickname,
        socialType: socialType,
        image: image ?? KKDS.Image.ic_my_img_86
      )
    } catch {

      return UserDetail(
        nickname: nickname,
        socialType: socialType,
        image: KKDS.Image.ic_my_img_86
      )
    }
  }
}
