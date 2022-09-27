//
//  NetworkErrorType.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/14.
//

import Foundation

enum NetworkErrorType: Error {

  /// 유효하지 않은 URL 형식 오류.
  case invalidURLString

  /// 유효하지 않은 통신 오류.
  case invalidServerResponse
}
