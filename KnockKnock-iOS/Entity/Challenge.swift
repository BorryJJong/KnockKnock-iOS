//
//  Challenge.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/10.
//

import Foundation

struct Challenge: Decodable {
  let id: Int
  let title: String
  let subTitle: String
  let mainImage: String
  let isHotBadge: Bool
  let isNewBadge: Bool
  let participants: [Participant]
  let participantCount: Int

  struct Participant: Decodable {
    let id: Int
    let image: String?
  }
}

struct ChallengeDetail: Decodable {
  let challenge: Header
  let participants: [Participant]
  let content: Content

  struct Participant: Decodable {
    let id: Int
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
