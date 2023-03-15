//
//  HomeBanner.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/19.
//

import Foundation

struct HomeBannerDTO: Decodable {
  let id: Int
  let image: String
  let targetScreen: String
}

struct HomeBanner: Decodable {
  let id: Int
  let image: String
  let targetScreen: BannerTagrget?
}

extension HomeBannerDTO {
  func toDomain() -> HomeBanner {
    return .init(
      id: id,
      image: image,
      targetScreen: BannerTagrget(rawValue: targetScreen)
    )
  }
}
