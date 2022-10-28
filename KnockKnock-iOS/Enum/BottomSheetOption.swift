//
//  BottomSheetOptions.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/29.
//

import UIKit

enum BottomSheetOption: String {
  case delete = "삭제"
  case edit = "수정"
  case report = "신고하기"
  case share = "공유하기"
  case hide = "숨기기"
}

enum BottomSheetType: CGFloat {
  case small = 0.9
  case medium = 0.8
  case large = 0.3
//  case full = 0.2
}
