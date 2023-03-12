//
//  StoreDetail.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/24.
//

import Foundation

struct StoreDetail: Decodable {
  let id: Int
  let name: String
  let description: String
  let image: String
  let shopPromotionNames: [String]
  let url: URL?
  let locationX: String // 경도
  let locationY: String // 위도
}
