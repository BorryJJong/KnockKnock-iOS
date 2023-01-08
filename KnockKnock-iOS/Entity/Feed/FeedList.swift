//
//  Feed.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/23.
//

import Foundation

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
    let isWriter: Bool
  }

  struct Image: Decodable {
    let id: Int
    let fileUrl: String
  }
}
