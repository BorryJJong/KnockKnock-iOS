//
//  Promotion.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/03.
//

import Foundation

struct PromotionInfo: Decodable {
  let id: Int
  let type: String
}

struct Promotion {
  let promotionInfo: PromotionInfo
  var isSelected: Bool
}
