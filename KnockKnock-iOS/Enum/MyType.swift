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

enum MySectionType: String {
  case myInfo = "내 정보"
  case customer = "고객지원"
  case policy = "약관 및 정책"
}

enum MyMenuType: String {
  case profile = "프로필 수정"
  case withdraw = "탈퇴하기"
  case pushNotification = "앱 PUSH 알림"

  case versionInfo = "버전정보"

  case privacy = "개인정보 처리방침"
  case opensource = "오픈소스 라이선스"

  var url: String? {
    switch self {

    case .privacy:
      return "https://glib-brow-cf2.notion.site/KnockKnock-09c388824e12462d8d7a56d09042558c"

    case .opensource:
      return "https://glib-brow-cf2.notion.site/KnockKnock-41c07a7b6e8c4084a4899485ae28967e"

    default:
      return nil
    }
  }
}
