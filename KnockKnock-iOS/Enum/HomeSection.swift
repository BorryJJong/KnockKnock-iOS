//
//  HomeSection.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/23.
//

import Foundation

enum HomeSection: Int {
  case main = 0
  case store = 1
  case banner = 2
  case tag = 3
  case popularPost = 4
  case event = 5

  static let allCases: [HomeSection] = [.main, .store, .banner, .tag, .popularPost, .event]
}
