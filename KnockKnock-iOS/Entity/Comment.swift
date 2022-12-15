//
//  Comment.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/19.
//

import Foundation

struct CommentResponse: Decodable {
  let data: [Data]?

  struct Data: Decodable {
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
}

/// View에서 사용하는 comment model
struct Comment: Decodable {
  let data: CommentResponse.Data
  
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

struct DeleteCommentResponse: Decodable {
  let code: Int
  let message: String
}
