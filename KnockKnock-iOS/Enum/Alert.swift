//
//  AlertMessage.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/07.
//

import Foundation

enum Alert {
  case signOut
  case versionInfo

  var message: String {
    switch self {
    case .signOut:
      return "계정을 삭제하면 게시글, 좋아요, 댓글 등 모든 활동 정보가 삭제됩니다. 그래도 탈퇴 하시겠습니까?"

    case .versionInfo:
        return "현재 최신버전을 사용중입니다."
    }
  }
}
