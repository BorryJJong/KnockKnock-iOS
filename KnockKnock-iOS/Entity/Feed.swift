//
//  Feed.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/23.
//

import Foundation

struct Feed: Codable {
  let userId: Int
  let content: String
//  let storeAddress: String
//  let locationX: String
//  let locationY: String
//  let promotions: String
//  let challenges: String
  let images: [String]
}
