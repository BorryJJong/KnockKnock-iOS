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
  case signOut = "탈퇴하기"
  case pushNotification = "앱 PUSH 알림"

  case notice = "공지사항"
  case versionInfo = "버전정보"

  case serviceTerms = "서비스 이용약관"
  case privacy = "개인정보 처리방침"
  case locationService = "위치기반 서비스 이용약관"
  case opensource = "오픈소스 라이선스"
}
