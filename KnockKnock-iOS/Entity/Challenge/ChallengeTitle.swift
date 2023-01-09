//
//  ChallengeTitle.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/09.
//

import Foundation

struct ChallengeTitleDTO: Decodable {
  let id: Int
  let title: String
}

struct ChallengeTitle {
  let id: Int
  let title: String
  var isSelected: Bool = false
}

extension ChallengeTitleDTO {
  func toDomain() -> ChallengeTitle {

    return .init(id: self.id,
                 title: self.title)
  }
}
