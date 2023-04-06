//
//  BannerTarget.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/03/15.
//

import Foundation

/// 배너를 클릭했을 때 전환 될 화면에 대한 데이터
enum BannerTagrget: String, Decodable {
  
  case feedWrite = "FEED_WRITE"
  case challengeGogo = "CHALLENGE_GOGO"
  case challengeUpcycling = "CHALLENGE_UPCYCLING"
  case challengeBrave = "CHALLENGE_BRAVE"

  var challengId: Int? {

    switch self {

    case .challengeGogo:
      return 12

    case .challengeUpcycling:
      return 13

    case .challengeBrave:
      return 14

    default:
      return nil
    }
  }
}
