//
//  FeedWrite.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/05.
//

import UIKit

// MARK: - 피드 등록

/// 피드 등록 entity
struct FeedWrite {
  let content: String
  let storeAddress: String
  let locationX: String
  let locationY: String
  let scale: String
  let promotions: String
  let challenges: String
  let images: [UIImage]
}

// MARK: - 매장검색

/// Kakao local api
struct AddressResult: Codable {
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
