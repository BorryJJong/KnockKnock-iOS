//
//  Like.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/02.
//

import Foundation

struct Like: Decodable {
  let userId: Int
  let nickname: String
  let image: String?
}
