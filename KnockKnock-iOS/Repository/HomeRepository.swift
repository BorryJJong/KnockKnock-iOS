//
//  HomeRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/17.
//

import Foundation

protocol HomeRepositoryProtocol {
  func requestHotPost(
    challengeId: Int,
    completionHandler: @escaping ([HotPost]) -> Void
  )
  func requestChallengeTitles(
    completionHandler: @escaping ([ChallengeTitle]) -> Void
  )
  func requestEventList() async -> [Event]
}

final class HomeRepository: HomeRepositoryProtocol {

  /// 인기 게시글 조회
  func requestHotPost(
    challengeId: Int,
    completionHandler: @escaping ([HotPost]) -> Void
  ) {

    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<[HotPostDTO]>.self,
        router: KKRouter.getHotPost(challengeId: challengeId),
        success: { response in
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data.map{$0.toDomain()})
        }, failure: { error in
          print(error)
        }
      )
  }

  /// 태그 리스트(인기 게시글 필터용)
  func requestChallengeTitles(
    completionHandler: @escaping ([ChallengeTitle]) -> Void
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<[ChallengeTitleDTO]>.self,
        router: KKRouter.getChallengeTitles,
        success: { response in
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data.map{$0.toDomain()})
        }, failure: { error in
          print(error)
        }
      )
  }

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
}
