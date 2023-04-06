//
//  Challenge.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/10.
//

import Foundation

struct Challenge: Decodable {
  let challengeTotalCount: Int
  let challengeNewCount: Int
  let challenges: [Data]

  struct Data: Decodable {
    let id: Int
    let title: String
    let subTitle: String

    let mainImage: String
    let isHotBadge: Bool
    let isNewBadge: Bool
    let participants: [Participant]
    let participantCount: Int
  }

  struct Participant: Decodable {
    let id: Int
    let image: String?
  }
}

struct ChallengeDTO: Decodable {
  let challengeTotalCount: Int
  let challengeNewCount: Int
  let challenges: [Data]

  struct Data: Decodable {
    let id: Int
    let title: String
    let subTitle: String

    let mainImage: String
    let isHotBadge: Bool
    let isNewBadge: Bool
    let participants: [Participant]
    let participantCount: Int
  }

  struct Participant: Decodable {
    let id: Int
    let image: String?
  }
}

extension ChallengeDTO {

  func toDomain() -> Challenge {
    return .init(
      challengeTotalCount: challengeTotalCount,
      challengeNewCount: challengeNewCount,
      challenges: challenges.map {
        Challenge.Data(
          id: $0.id,
          title: $0.title,
          subTitle: $0.subTitle,
          mainImage: $0.mainImage,
          isHotBadge: $0.isHotBadge,
          isNewBadge: $0.isNewBadge,
          participants: $0.participants.map {
            Challenge.Participant(
              id: $0.id,
              image: $0.image
            )
          },
          participantCount: $0.participantCount
        )
      }
    )
  }

}
