//
//  ApiResponseDTO.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/09.
//

import Foundation

/// API 응답 값 default 구조
/// - code: status code(e.g. 200, 400)
/// - message: 성공 여부 (e.g. SUCCESS or FAIL)
/// - data: 데이터 부분
struct ApiResponseDTO<T: Decodable>: Decodable {
  let code: Int
  let message: String
  let data: T?
}
