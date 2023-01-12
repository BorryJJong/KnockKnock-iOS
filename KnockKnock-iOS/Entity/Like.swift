//
//  Like.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/02.
//

import Foundation

struct Like: Decodable {
  let postId: String
  let likes: [Info]

  struct Info: Decodable {
    let id: Int
    let userId: Int
    let userName: String
    let userImage: String?
  }
}
