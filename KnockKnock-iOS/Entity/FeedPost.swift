//
//  Feed.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/23.
//

import Foundation

struct FeedPost: Decodable {
  let id: Int
  let userId: Int
  let content: String
  let storeAddress: String
  let locationX: String
  let locationY: String
  let regDate: String
  let userName: String
  let userImage: String?
  let scale: String = "1:1"
}

struct FeedDetail: Decodable {
  let data: FeedDetailData
}

struct FeedDetailData: Decodable {
  let feed: FeedPost?
  let promotions: [Promotion]
  let challenges: [Challenge]
  let images: [FeedImage]
}

struct Promotion: Decodable {
  let id: Int
  let promotionId: Int
  let title: String
}

struct Challenge: Decodable {
  let id: Int
  let challengeId: Int
  let title: String
}

struct FeedMain: Decodable {
  let isNext: Bool
  let total: Int
  let feeds: [FeedMainPost]
}

struct FeedMainPost: Decodable {
  let id: Int
  let thumbnailUrl: String
  let isImageMore: Bool
}

// MARK: - 매장검색

struct AddressResult: Codable {
  let meta: AddressMeta
  let documents: [AddressDocuments]
}

struct AddressMeta: Codable {
  let pageableCount: Int
  let totalCount: Int
  let isEnd: Bool

  enum CodingKeys: String, CodingKey {
    case pageableCount = "pageable_count"
    case totalCount = "total_count"
    case isEnd = "is_end"
  }
}

struct AddressDocuments: Codable {
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

struct FeedList: Decodable {
  let feeds: [FeedListPost]
  let isNext: Bool
  let total: Int
}

struct FeedListPost: Decodable {
  let id: Int
  let userName: String
  let userImage: String
  let regDateToString: String
  let content: String?
  let imageScale: String = "1:1"
  let blogLikeCount: String
  let isLike: Bool
  let blogCommentCount: String
  let blogImages: [FeedImage]
}

struct FeedImage: Decodable {
  let id: Int
  let fileUrl: String
}
