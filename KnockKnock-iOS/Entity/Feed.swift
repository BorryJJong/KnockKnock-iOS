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
  let images: [String]
  let scale: String
}
