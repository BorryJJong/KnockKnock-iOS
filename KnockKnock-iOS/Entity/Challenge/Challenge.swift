//
//  Challenge.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/05.
//

import Foundation

struct Challenge: Decodable {
  let id: Int
  let title: String
  let subTitle: String
  let content: String
  let regDate: String
  let newYn: String // 새로운 게시물
  let postCnt: String // 최신순?
  let rnk: String // 인기순위?
  let participants: [Participant]

  struct Participant: Decodable {
    let id: Int
    let nickname: String
    let image: String?
  }
}

struct ChallengeDetail: Decodable {
  let challenge: Header
  let participants: [Participant]
  let content: Content

  struct Participant: Decodable {
    let id: Int
    let nickname: String
    let image: String?
  }

  struct Header: Decodable {
    let id: Int
    let title: String
    let subTitle: String
  }

  struct Content: Decodable {
    let image: String?
    let rule: [String]
    let subContents: [SubContents]
  }

  struct SubContents: Decodable {
    let title: String
    let image: String?
    let content: String
  }
}
