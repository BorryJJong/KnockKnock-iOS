//
//  MyType.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/17.
//

import Foundation

/// My tab menu type
/// - plain: '>'
/// - version: version info + '>'
/// - alert: switch
enum MyType {
  case plain
  case version
  case alert
}

enum MySection: String {
  case myInfo = "내 정보"
  case customer = "고객지원"
  case policy = "약관 및 정책"
}
