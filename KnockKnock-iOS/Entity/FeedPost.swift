//
//  Feed.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/23.
//

import Foundation
import UIKit

struct FeedMain: Decodable {
  let isNext: Bool
  let total: Int
  let feeds: [Post]

  struct Post: Decodable {
    let id: Int
    let thumbnailUrl: String
    let isImageMore: Bool
  }
}

struct FeedList: Decodable {
  let feeds: [Post]
  let isNext: Bool
  let total: Int

  struct Post: Decodable {
    let id: Int
    let userName: String
    let userImage: String?
    let regDateToString: String
    let content: String?
    let imageScale: String = "1:1"
    let blogLikeCount: String
    let isLike: Bool
    let blogCommentCount: String
    let blogImages: [Image]
  }

  struct Image: Decodable {
    let id: Int
    let fileUrl: String
  }
}

struct FeedDetail: Decodable {
  let data: Data

  struct Data: Decodable {
    let feed: Post?
    let promotions: [Promotion]
    let challenges: [Challenge]
    let images: [Image]
  }

  struct Post: Decodable {
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

  struct Image: Decodable {
    let id: Int
    let fileUrl: String
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
}
