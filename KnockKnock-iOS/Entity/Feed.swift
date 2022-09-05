//
//  Feed.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/23.
//

import Foundation

struct Feed: Decodable {
  let userId: Int
  let content: String
  let images: [String]
  let scale: String
}

struct FeedDetail: Decodable {
  let id: Int
  let userId: Int
  let content: String
  let storeAddress: String
  let locationX: String
  let locationY: String
  let regDate: String
  let nickname: String
  let image: String?
  let promotions: [Promotion]
  let challenge: [Challenge]
  let images: [String]
  let scale: String
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
