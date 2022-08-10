//
//  FeedDetailSection.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/27.
//

import UIKit

enum FeedDetailSection: Int {
  case content = 0
  case like = 1
  case comment = 2

  static let allCases: [FeedDetailSection] = [.content, .like, .comment]
}
