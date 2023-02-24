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
}
