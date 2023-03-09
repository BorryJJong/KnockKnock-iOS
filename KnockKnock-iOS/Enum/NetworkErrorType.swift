//
//  NetworkErrorType.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/14.
//

import Foundation

enum NetworkErrorType: Error {

  case unknownedError
  case networkFail

  var message: String {

    switch self {

    case .networkFail:
      return "네트워크 연결상태를 확인해주세요."

    case .unknownedError:
      return "알 수 없는 오류가 발생하였습니다."
    }
  }
}
