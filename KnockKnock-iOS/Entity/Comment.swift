//
//  Comment.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/19.
//

import Foundation

struct CommentResponse: Decodable {
  let data: [CommentData]?
}

struct CommentData: Decodable {
  let id: Int
  let userId: Int
  let nickname: String
  let image: String?
  let content: String
  let regDate: String
  let isDeleted: Bool
  let replyCnt: Int
  let reply: [Reply]?
}

struct Reply: Decodable {
  let id: Int
  let userId: Int
  let nickname: String
  let image: String?
  let content: String
  let regDate: String
  let isDeleted: Bool
}

struct Comment: Decodable {
  let commentData: CommentData
  
  var isOpen: Bool = false
  var isReply: Bool = false
}

struct AddCommentRequest {
  let feedId: Int
  let userId: Int
  let content: String
  let commentId: Int?
}

struct AddCommentResponse: Decodable {
  let code: Int
  let message: String
}
