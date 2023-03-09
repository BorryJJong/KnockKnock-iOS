//
//  EventDetail.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/15.
//

import Foundation

struct EventDetailDTO: Decodable {
  let id: Int
  let isNewBadge: Bool
  let isEndEvent: Bool
  let title: String
  let eventPeriod: String
  let image: String
  let url: String
}

struct EventDetail: Decodable {
  let id: Int
  let isNewBadge: Bool
  let isEndEvent: Bool
  let title: String
  let eventPeriod: String
  let image: String
  let url: URL?
}

extension EventDetailDTO {

  func toDomain() -> EventDetail {
    return .init(
      id: id,
      isNewBadge: isNewBadge,
      isEndEvent: isEndEvent,
      title: title,
      eventPeriod: eventPeriod,
      image: image,
      url: URL(string: url)
    )
  }
}
