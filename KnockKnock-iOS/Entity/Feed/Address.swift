//
//  Address.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/05.
//

import Foundation

/// Kakao local api
struct AddressResponse: Codable {
  let meta: Meta
  let documents: [Documents]

  struct Meta: Codable {
    let pageableCount: Int
    let totalCount: Int
    let isEnd: Bool

    enum CodingKeys: String, CodingKey {
      case pageableCount = "pageable_count"
      case totalCount = "total_count"
      case isEnd = "is_end"
    }
  }

  struct Documents: Codable {
    let placeName: String
    let addressName: String
    let roadAddressName: String
    let longtitude: String
    let latitude: String

    enum CodingKeys: String, CodingKey {
      case placeName = "place_name"
      case addressName = "address_name"
      case roadAddressName = "road_address_name"
      case longtitude = "x"
      case latitude = "y"
    }
  }
}
