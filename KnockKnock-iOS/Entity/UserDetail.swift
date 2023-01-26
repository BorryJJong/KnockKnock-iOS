//
//  UserDetail.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/26.
//

import UIKit

struct UserDetail: Decodable {
  let nickname: String
  let socialType: String
  let image: String?
}
