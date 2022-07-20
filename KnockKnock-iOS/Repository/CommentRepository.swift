//
//  CommentRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/20.
//

import Foundation

import Alamofire

protocol CommentRepositoryProtocol {
  func getComments(completionHandler: @escaping ([Comment]) -> Void)
}

final class CommentRepository: CommentRepositoryProtocol {
  func getComments(completionHandler: @escaping ([Comment]) -> Void) {
    let dummyComments: [Comment] = [
      Comment(userID: "user1", image: "", contents: "댓글입니다댓글입니다댓글입니다댓글입니다댓글입니다",
              replies: [
                Reply(userID: "user2", image: "", contents: "retewar", date: "0201223"),
                Reply(userID: "user3", image: "", contents: "asdfwegqegweqgwerwerwsdaf", date: "0201223"),
                Reply(userID: "user2", image: "", contents: "retwegwelkwje;lkfjw;elfkjw;lkewar", date: "0201223")
              ], date: "123kj12"),

      Comment(userID: "user1", image: "", contents: "갖;ㅁㄷ기ㅓㅈ딥;ㅏ겆ㅂ디;ㅏ거;ㅣ나얾;ㅣㄴ아ㅓ히;ㅏ엏ㅈ;ㅣ다ㅜ;ㅣㅏ",
              replies: [
                Reply(userID: "user2", image: "", contents: "retewar", date: "0201223"),
                Reply(userID: "user2", image: "", contents: "retwegwelkwje;lkfjw;elfkjw;lkewar", date: "0201223")
              ], date: "123kj12"),

      Comment(userID: "user1", image: "", contents: "댓글입니다댓글입니다댓글입니다댓글입니다댓글입니다",
              replies: [
              ], date: "123kj12"),

      Comment(userID: "user1", image: "", contents: "댓글입니다댓글입니다댓글입니다댓글입니다댓글입니다",
              replies: [
                Reply(userID: "user2", image: "", contents: "retewar", date: "0201223"),
                Reply(userID: "user3", image: "", contents: "asdfwegqegweqgwerwerwsdaf", date: "0201223"),
                Reply(userID: "user2", image: "", contents: "retwegwelkwje;lkfjw;elfkjw;lkewar", date: "0201223")
              ], date: "123kj12")
    ]
    completionHandler(dummyComments)
  }
}
