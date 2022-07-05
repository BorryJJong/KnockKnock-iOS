//
//  Challenge.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/05.
//

import Foundation

struct Challenges: Decodable {
  let id: Int
  let title: String
  let subTitle: String
  let content: String
  let regDate: String
  let newYn: String // 새로운 게시물
  let postCnt: String // 최신순?
  let rnk: String // 인기순위?
  let participants: [Participant]
}

struct Participant: Decodable {
  let id: Int
  let nickname: String
  let image: String?
}
