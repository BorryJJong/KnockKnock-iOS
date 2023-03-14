//
//  EventRepositoryProtocol.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/20.
//

import Foundation

protocol EventRepositoryProtocol {
  func requestEventList() async -> ApiResponse<[Event]>?
  func requestEventDetailList(eventTapType: EventTapType) async -> ApiResponse<[EventDetail]>?
}

final class EventRepository: EventRepositoryProtocol {

  /// 이벤트 목록 조회
  func requestEventList() async -> ApiResponse<[Event]>? {

    do {
      let result = try await KKNetworkManager
        .shared
        .asyncRequest(
          object: ApiResponse<[EventDTO]>.self,
          router: .getHomeEvent
        )

      guard let data = result.value else { return nil }

      return ApiResponse(
        code: data.code,
        message: data.message,
        data: data.data?.map{ $0.toDomain() }
      )

    } catch {

      print(error.localizedDescription)
      return nil
    }
  }

  /// 이벤트 상세 조회
  ///
  /// - Parameters:
  ///  - eventTapType: 이벤트 상태 (종료/진행)
  func requestEventDetailList(eventTapType: EventTapType) async -> ApiResponse<[EventDetail]>? {
    do {

      let result = try await KKNetworkManager
        .shared
        .asyncRequest(
          object: ApiResponse<[EventDetailDTO]>.self,
          router: .getEvent(eventTap: eventTapType.rawValue)
        )
      
      guard let data = result.value else { return nil }

      return ApiResponse(
        code: data.code,
        message: data.message,
        data: data.data?.map{ $0.toDomain() }
      )

    } catch {

      print(error.localizedDescription)
      return nil
    }
  }
}
