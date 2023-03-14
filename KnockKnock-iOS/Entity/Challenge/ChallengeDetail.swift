//
//  ChallengeDetail.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/03/13.
//

import Foundation

struct ChallengeDetailDTO: Decodable {
  let id: Int
  let title: String
  let subTitle: String
  let contentImage: String

  let participants: [Participant]
  let content: Content

  struct Participant: Decodable {
    let id: Int
    let image: String?
  }

  struct Content: Decodable {
    let rule: [String]
    let subContents: [SubContents]
  }

  struct SubContents: Decodable {
    let title: String
    let image: String?
    let content: String
  }
}

struct ChallengeDetail: Decodable {
  let id: Int
  let title: String
  let subTitle: String
  let contentImage: String

  let participants: [Participant]
  let content: Content

  struct Participant: Decodable {
    let id: Int
    let image: String?
  }

  struct Content: Decodable {
    let rule: [String]
    let subContents: [SubContents]
  }

  struct SubContents: Decodable {
    let title: String
    let image: String?
    let content: String
  }
}

extension ChallengeDetailDTO {

  func toDomain() -> ChallengeDetail {
    return .init(
      id: id,
      title: title,
      subTitle: subTitle,
      contentImage: contentImage,
      participants: participants.map {
        ChallengeDetail.Participant(
          id: $0.id,
          image: $0.image
        )
      },
      content: ChallengeDetail.Content(
        rule: content.rule,
        subContents:
          content.subContents.map {
            ChallengeDetail.SubContents(
              title: $0.title,
              image: $0.image,
              content: $0.content
            )
          }
      )
    )
  }
}
