//
//  ErrorType.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/23.
//

import Foundation

public enum ErrorType {

  case no_kakaotalk_installation

  var message: String {
    switch self {
    case .no_kakaotalk_installation:
      return "카카오톡 미설치 디바이스 입니다."
      
    }
  }
}
