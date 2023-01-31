//
//  BottomSheetOptions.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/29.
//

import UIKit

enum BottomSheetOption: String {
  case postDelete = "삭제"
  case postEdit = "수정"
  case postReport = "신고하기"
  case postShare = "공유하기"
  case postHide = "숨기기"
  case challengeNew = "최신순"
  case challengePopular = "인기순"
}

enum BottomSheetType: CGFloat {
  case small = 0.85
  case medium = 0.8
  case large = 0.3
}
