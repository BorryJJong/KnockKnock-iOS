//
//  StoreDetailDTO.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/24.
//

import Foundation

struct StoreDetailDTO: Decodable {
  let id: Int
  let name: String
  let description: String
  let image: String
  let shopPromotionNames: [String]
  let url: String
  let locationX: String // 경도
  let locationY: String // 위도
}

extension StoreDetailDTO {
  func toDomain() -> StoreDetail {
    return .init(
      id: id,
      name: name,
      description: description,
      image: image,
      shopPromotionNames: shopPromotionNames,
      url: URL(string: url),
      locationX: locationX,
      locationY: locationY
    )
  }
}
