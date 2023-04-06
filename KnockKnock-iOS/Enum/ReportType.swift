//
//  ReportType.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/08.
//

import Foundation

enum ReportType: String, CaseIterable {
  case inappropriateContent = "INAPPROPRIATE_CONTENT"
  case unauthorizeUse = "UNAUTHORIZED_USE"
  case personalInfoExtrusion = "PERSONAL_INFORMATION_EXTRUSION"

  var message: String {
    switch self {

    case .inappropriateContent:
      return "음란/욕설/비방 등 부적절한 내용"

    case .unauthorizeUse:
      return "저작권 및 초상권 무단 도용"

    case .personalInfoExtrusion:
      return "개인정보 유출"
    }
  }
}
