//
//  BottomSheetOption.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/26.
//

import Foundation

enum BottomSheetOption {
  typealias Action = (() -> Void)?

  case postDelete(Action)
  case postEdit(Action)
  case postReport(Action)
  case postShare
  case postHide(Action)
  case userBlock(Action)
  case challengeNew
  case challengePopular

  var title: String {
    switch self {
    case .postDelete:
      return "삭제"

    case .postEdit:
      return "수정"

    case .postReport:
      return "신고하기"

    case .postShare:
      return "공유하기"

    case .postHide:
      return "숨기기"

    case .userBlock:
      return "차단하기"

    case .challengeNew:
      return "최신순"

    case .challengePopular:
      return "인기순"
    }
  }

  func getAction() -> (() -> Void)? {
    switch self {
    case .postDelete(let action):
      return action
      
    case .postEdit(let action):
      return action

    case .postReport(let action):
      return action

    case .postShare:
      return nil

    case .postHide(let action):
      return action

    case .userBlock(let action):
      return action

    case .challengeNew,
         .challengePopular:
      return nil
    }
  }
}
