//
//  Promotion.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/03.
//

import Foundation

struct Promotion: Decodable, Equatable {
  let id: Int
  let type: String
}

struct SelectablePromotion {
  let promotionInfo: Promotion
  var isSelected: Bool
}
