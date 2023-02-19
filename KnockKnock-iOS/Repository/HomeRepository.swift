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
  func requestBanner(bannerType: BannerType) async -> [HomeBanner]?
}

final class HomeRepository: HomeRepositoryProtocol {

  /// 홈 메인/바 배너 조회
  ///
  /// - Parameters:
  ///  - bannerType: 배너 형태(메인/바)
  func requestBanner(bannerType: BannerType) async -> [HomeBanner]? {
    do {

      let result = try await KKNetworkManager
        .shared
        .asyncRequest(
          object: ApiResponseDTO<[HomeBannerDTO]>.self,
          router: .getBanner(bannerType: bannerType.rawValue)
        )

      guard let data = result.data else { return nil }
      return data.map { $0.toDomain() }

    } catch {
      print(error)
      
      return nil
    }
  }

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
