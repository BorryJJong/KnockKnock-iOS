//
//  Event.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/14.
//

import Foundation

struct EventDTO: Decodable {
  let id: Int
  let isNewBadge: Bool
  let title: String
  let eventPeriod: String
  let image: String
}

struct Event: Decodable {
  let id: Int
  let isNewBadge: Bool
  let title: String
  let eventPeriod: String
  let image: String
}

extension EventDTO {

  func toDomain() -> Event {
    return .init(
      id: id,
      isNewBadge: isNewBadge,
      title: title,
      eventPeriod: eventPeriod,
      image: image
    )
  }
}
