//
//  Promotion.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/03.
//

import Foundation

struct PromotionDTO: Decodable {
  let id: Int
  let type: String
}

extension PromotionDTO {
  func toDomain() -> Promotion {
    return .init(id: self.id,
                 type: self.type,
                 isSelected: false)
  }
}

struct Promotion {
  let id: Int
  let type: String

  var isSelected: Bool
}
