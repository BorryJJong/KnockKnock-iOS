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
  let replies: [Reply]
  let date: String
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

let modelObjects = [
  Comment(userID: "user1", image: "", contents: "댓글입니다댓글입니다댓글입니다댓글입니다댓글입니다", replies: [
    Reply(userID: "user2", image: "", contents: "retewar", date: "0201223"),
    Reply(userID: "user3", image: "", contents: "asdfwegqegweqgwerwerwsdaf", date: "0201223"),
    Reply(userID: "user2", image: "", contents: "retwegwelkwje;lkfjw;elfkjw;lkewar", date: "0201223")
  ], date: "123kj12"),

  Comment(userID: "user1", image: "", contents: "갖;ㅁㄷ기ㅓㅈ딥;ㅏ겆ㅂ디;ㅏ거;ㅣ나얾;ㅣㄴ아ㅓ히;ㅏ엏ㅈ;ㅣ다ㅜ;ㅣㅏ", replies: [
    Reply(userID: "user2", image: "", contents: "retewar", date: "0201223"),
    Reply(userID: "user2", image: "", contents: "retwegwelkwje;lkfjw;elfkjw;lkewar", date: "0201223")
  ], date: "123kj12"),

  Comment(userID: "user1", image: "", contents: "댓글입니다댓글입니다댓글입니다댓글입니다댓글입니다", replies: [
  ], date: "123kj12"),

  Comment(userID: "user1", image: "", contents: "댓글입니다댓글입니다댓글입니다댓글입니다댓글입니다", replies: [
    Reply(userID: "user2", image: "", contents: "retewar", date: "0201223"),
    Reply(userID: "user3", image: "", contents: "asdfwegqegweqgwerwerwsdaf", date: "0201223"),
    Reply(userID: "user2", image: "", contents: "retwegwelkwje;lkfjw;elfkjw;lkewar", date: "0201223")
  ], date: "123kj12")
]
