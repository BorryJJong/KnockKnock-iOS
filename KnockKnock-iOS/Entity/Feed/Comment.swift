//
//  Comment.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/19.
//

import Foundation

struct CommentDTO: Decodable {
  let id: Int
  let userId: Int
  let nickname: String
  let image: String?
  let content: String
  let regDate: String
  let isDeleted: Bool
  let replyCnt: Int
  let reply: [Reply]?

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

  var data: Data

  struct Data: Decodable {
    let id: Int
    let userId: Int
    let nickname: String
    let image: String?
    let content: String
    let regDate: String
    var isDeleted: Bool
    let replyCnt: Int
    var reply: [Reply]?

    struct Reply: Decodable {
      let id: Int
      let userId: Int
      let nickname: String
      let image: String?
      let content: String
      let regDate: String
      var isDeleted: Bool
    }
  }

  var isOpen: Bool = false
  var isReply: Bool = false
}

extension CommentDTO {

  func toDomain() -> Comment {
    return .init(
      data: Comment.Data(
        id: id,
        userId: userId,
        nickname: nickname,
        image: image,
        content: content,
        regDate: regDate,
        isDeleted: isDeleted,
        replyCnt: replyCnt,
        reply: reply?.map {
          Comment.Data.Reply(
            id: $0.id,
            userId: $0.userId,
            nickname: $0.nickname,
            image: $0.image,
            content: $0.content,
            regDate: $0.regDate,
            isDeleted: $0.isDeleted
          )
        }
      )
    )
  }
}
