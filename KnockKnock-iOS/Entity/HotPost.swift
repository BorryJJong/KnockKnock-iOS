//
//  HotPost.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/17.
//

import UIKit

struct HotPostDTO: Decodable {
  let postId: Int
  let scale: String
  let nickname: String
  let fileUrl: String

  func toDomain() -> HotPost {
    .init(postId: postId,
          scale: "1:1",
          nickname: nickname,
          fileUrl: fileUrl)
  }
}

struct HotPost {
  let postId: Int
  let scale: String
  let nickname: String
  let fileUrl: String
}
