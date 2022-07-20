//
//  Comment.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/19.
//

import Foundation

struct Comment: Decodable {
  let userID: String
  let image: String
  let contents: String
  var replies: [Reply]
  let date: String

  var isOpen: Bool = false
}

struct Reply: Decodable {
  let userID: String
  let image: String
  let contents: String
  let date: String
}

enum ListItem: Decodable {
  case comment(Comment)
  case reply(Reply)
}
