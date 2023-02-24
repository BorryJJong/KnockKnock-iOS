//
//  EventRepositoryProtocol.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/20.
//

import Foundation

protocol EventRepositoryProtocol {
  func requestEventList() async -> [Event]
  func requestEventDetailList(eventTapType: EventTapType) async -> [EventDetail]?
}

final class EventRepository: EventRepositoryProtocol {

  /// 이벤트 목록 조회
  func requestEventList() async -> [Event] {
    do {
      let result = try await KKNetworkManager
        .shared
        .asyncRequest(
          object: ApiResponseDTO<[EventDTO]>.self,
          router: .getHomeEvent
        )

      guard let data = result.data else { return [] }
      return data.map { $0.toDomain() }

    } catch let error {
      print(error)

      return []
    }
  }

  /// 이벤트 상세 조회
  ///
  /// - Parameters:
  ///  - eventTapType: 이벤트 상태 (종료/진행)
  func requestEventDetailList(eventTapType: EventTapType) async -> [EventDetail]? {
    do {
      let result = try await KKNetworkManager
        .shared
        .asyncRequest(
          object: ApiResponseDTO<[EventDetailDTO]>.self,
          router: .getEvent(eventTap: eventTapType.rawValue)
        )

      guard let data = result.data else { return nil }
      return data.map { $0.toDomain() }

    } catch let error {
      print(error)

      return nil
    }
  }
}
