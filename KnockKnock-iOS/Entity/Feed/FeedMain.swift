//
//  FeedMain.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/05.
//

import Foundation

struct FeedMainDTO: Decodable {
  let isNext: Bool
  let total: Int
  let feeds: [Post]

  struct Post: Decodable {
    let id: Int
    let thumbnailUrl: String
    let isImageMore: Bool
  }
}

struct FeedMain: Decodable {
  var isNext: Bool
  let total: Int
  var feeds: [Post]

  struct Post: Decodable {
    let id: Int
    let thumbnailUrl: String
    let isImageMore: Bool
  }
}

extension FeedMainDTO {
  func toDomain() -> FeedMain {
    return .init(
      isNext: isNext,
      total: total,
      feeds: feeds.map {
        FeedMain.Post(
          id: $0.id,
          thumbnailUrl: $0.thumbnailUrl,
          isImageMore: $0.isImageMore
        )
      }
    )
  }
}
