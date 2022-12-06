//
//  Feed.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/23.
//

import Foundation
import UIKit

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

struct Property: Equatable {
  let id: Int
  let title: String
}

struct FeedDetail: Decodable {
  let data: FeedDetailData
}

struct FeedDetailData: Decodable {
  let feed: FeedPost?
  let promotions: [PromotionData]
  let challenges: [Challenge]
  let images: [FeedImage]
}

struct PromotionData: Decodable {
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
