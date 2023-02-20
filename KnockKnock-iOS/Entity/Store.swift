//
//  Store.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/20.
//

import Foundation

struct StoreDTO: Decodable {
  let name: String
  let description: String
  let image: String
  let shopPromotionNames: [String]
}

struct Store: Decodable {
  let name: String
  let description: String
  let image: String
  let shopPromotionNames: [String]
}

extension StoreDTO {
  func toDomain() -> Store {
    return .init(
      name: name,
      description: description,
      image: image,
      shopPromotionNames: shopPromotionNames
    )
  }
}
