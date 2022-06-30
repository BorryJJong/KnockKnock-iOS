//
//  Challenge.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/05.
//

import Foundation

struct Challenges: Codable {
  let id: Int
  let content: String
  let title: String
}

struct ChallengeTitle: Codable {
  let id: Int
  let title: String
}
