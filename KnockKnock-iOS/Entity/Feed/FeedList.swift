//
//  FeedList.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/10.
//

import Foundation

struct FeedList: Decodable {
  var feeds: [Post]
  let isNext: Bool
  let total: Int

  struct Post: Decodable {
    let id: Int
    let userName: String
    let userImage: String?
    let regDateToString: String
    let content: String?
    let imageScale: String = "1:1"
    var blogLikeCount: String
    var isLike: Bool
    let blogCommentCount: String
    let blogImages: [Image]
    let isWriter: Bool
  }

  struct Image: Decodable {
    let id: Int
    let fileUrl: String
  }
}
