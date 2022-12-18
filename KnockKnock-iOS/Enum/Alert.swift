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
  case profileSetting
  case feedWriteDone
  case feedWriteNeedFill

  var message: String {
    switch self {
    case .signOut:
      return "계정을 삭제하면 게시글, 좋아요, 댓글 등 모든 활동 정보가 삭제됩니다. 그래도 탈퇴 하시겠습니까?"

    case .versionInfo:
      return "현재 최신버전을 사용중입니다."

    case .profileSetting:
      return "프로필 등록을 완료하였습니다."

    case .feedWriteDone:
      return "게시글 등록을 완료 하시겠습니까?"

    case .feedWriteNeedFill:
      return "사진, 태그, 프로모션, 내용은 필수 입력 항목입니다."
    }
  }
}
