//
//  FeedDetail.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/05.
//

import Foundation

struct FeedDetailDTO: Decodable {

  var feed: Post
  let promotions: [Promotion]
  let challenges: [Challenge]
  let images: [Image]

  struct Post: Decodable {
    let id: Int
    let userId: Int
    let content: String
    let storeAddress: String?
    let storeName: String?
    let locationX: String
    let locationY: String
    let regDate: String
    let userName: String
    let userImage: String?
    let scale: String = "1:1"
    var isLike: Bool
    let isWriter: Bool
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

  struct Image: Decodable {
    let id: Int
    let fileUrl: String
  }
}

extension FeedDetailDTO {
  func toDomain() -> FeedDetail {
    return .init(feed: FeedDetail.Post(
      id: feed.id,
      userId: feed.userId,
      content: feed.content,
      storeAddress: feed.storeAddress,
      storeName: feed.storeName,
      locationX: feed.locationX,
      locationY: feed.locationY,
      regDate: feed.regDate,
      userName: feed.userName,
      userImage: feed.userImage,
      isLike: feed.isLike,
      isWriter: feed.isWriter
    ), promotions: promotions.map {
      FeedDetail.Promotion(
        id: $0.id,
        promotionId: $0.promotionId,
        title: $0.title
      )
    }, challenges: challenges.map {
      FeedDetail.Challenge(
        id: $0.id,
        challengeId: $0.challengeId,
        title: $0.title
      )
    }, images: images.map {
      FeedDetail.Image(
        id: $0.id,
        fileUrl: $0.fileUrl
      )
    }
    )
  }
}

struct FeedDetail: Decodable {
  
  var feed: Post
  let promotions: [Promotion]
  let challenges: [Challenge]
  let images: [Image]
  
  struct Post: Decodable {
    let id: Int
    let userId: Int
    let content: String
    let storeAddress: String?
    let storeName: String?
    let locationX: String
    let locationY: String
    let regDate: String
    let userName: String
    let userImage: String?
    let scale: String = "1:1"
    var isLike: Bool
    let isWriter: Bool
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
  
  struct Image: Decodable {
    let id: Int
    let fileUrl: String
  }
}

extension FeedDetail {
  func toShare() -> FeedShare? {
    return FeedShare(
      id: feed.id,
      nickname: feed.userName,
      content: feed.content,
      imageUrl: images[0].fileUrl,
      likeCount: nil,
      commentCount: nil
    )
  }
}
