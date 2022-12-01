//
//  Like.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/02.
//

import Foundation

struct LikeResponse: Decodable {
  let data: LikeData
}

struct LikeData: Decodable {
  let postId: String
  let likes: [LikeInfo]
}

struct LikeInfo: Decodable {
  let id: Int
  let userId: Int
  let userName: String
  let userImage: String?
}
