//
//  HotPost.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/17.
//

import Foundation

struct HotPostDTO: Decodable {
  let postId: Int
  let scale: String
  let nickname: String
  let fileUrl: String
}

struct HotPost {
  let postId: Int
  let scale: String
  let nickname: String
  let fileUrl: String
}

extension HotPostDTO {
  func toDomain() -> HotPost {
    .init(
      postId: postId,
          scale: "1:1",
          nickname: nickname,
          fileUrl: fileUrl
    )
  }
}
