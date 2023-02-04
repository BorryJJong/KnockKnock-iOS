//
//  FeedMain.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/05.
//

import Foundation

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
