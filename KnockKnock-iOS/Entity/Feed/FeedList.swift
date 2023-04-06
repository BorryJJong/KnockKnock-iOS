//
//  FeedList.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/10.
//

import Foundation

struct FeedListDTO: Decodable {
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
    let isWriter: Bool
    let userId: Int

    func toShare() -> FeedShare? {
      
      return FeedShare(
        id: id,
        nickname: userName,
        content: content ?? "",
        imageUrl: blogImages[0].fileUrl,
        likeCount: blogLikeCount,
        commentCount: blogCommentCount
      )
    }
  }

  struct Image: Decodable {
    let id: Int
    let fileUrl: String
  }
}

struct FeedList: Decodable {
  var feeds: [Post]
  let isNext: Bool
  let total: Int

  struct Post: Decodable {
    let id: Int
    let userName: String
    let userImage: String?
    let regDateToString: String
    var content: String?
    let imageScale: String = "1:1"
    var blogLikeCount: String
    var isLike: Bool
    var blogCommentCount: String
    let blogImages: [Image]
    let isWriter: Bool
    let userId: Int

    func toShare() -> FeedShare? {

      return FeedShare(
        id: id,
        nickname: userName,
        content: content ?? "",
        imageUrl: blogImages[0].fileUrl,
        likeCount: blogLikeCount,
        commentCount: blogCommentCount
      )
    }
  }

  struct Image: Decodable {
    let id: Int
    let fileUrl: String
  }
}

extension FeedListDTO {
  func toDomain() -> FeedList {
    return .init(
      feeds: feeds.map {
        FeedList.Post(
          id: $0.id,
          userName: $0.userName,
          userImage: $0.userImage,
          regDateToString: $0.regDateToString,
          content: $0.content,
          blogLikeCount: $0.blogLikeCount,
          isLike: $0.isLike,
          blogCommentCount: $0.blogCommentCount,
          blogImages: $0.blogImages.map {
            FeedList.Image(
              id: $0.id,
              fileUrl: $0.fileUrl
            )
          },
          isWriter: $0.isWriter,
          userId: $0.userId
        )
      },
      isNext: isNext,
      total: total
    )
  }
}
