//
//  ErrorType.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/23.
//

import Foundation

public enum KakaoErrorType: Error {

  case unowned
  case no_kakaotalk_installation

  var message: String {
    
    switch self {
    case .unowned:
      return "공유하기를 실행 할 수 없습니다."
      
    case .no_kakaotalk_installation:
      return "카카오톡 미설치 디바이스 입니다."
      
    }
  }
}
