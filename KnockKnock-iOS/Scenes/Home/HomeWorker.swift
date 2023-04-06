//
//  HomeWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/23.
//

import Foundation

protocol HomeWorkerProtocol {
  func fetchHotPostList(
    challengeId: Int,
    completionHandler: @escaping (ApiResponse<[HotPost]>?) -> Void
  )
  func fetchChallengeList(
    completionHandler: @escaping(ApiResponse<[ChallengeTitle]>?) -> Void
  )
  func fetchEventList() async -> ApiResponse<[Event]>?
  func fetchBanner(bannerType: BannerType) async -> ApiResponse<[HomeBanner]>?
  func fetchVerifiedStore() async -> ApiResponse<[Store]>?
}

final class HomeWorker: HomeWorkerProtocol {

  private let verifiedStoreRepository: VerifiedStoreRepositoryProtocol
  private let hotPostRepository: HotPostRepositoryProtocol
  private let eventRepository: EventRepositoryProtocol
  private let bannerRepository: BannerRepositoryProtocol

  init(
    verifiedStoreRepository: VerifiedStoreRepositoryProtocol,
    hotPostRepository: HotPostRepositoryProtocol,
    eventRepository: EventRepositoryProtocol,
    bannerRepository: BannerRepositoryProtocol
  ) {
    self.verifiedStoreRepository = verifiedStoreRepository
    self.hotPostRepository = hotPostRepository
    self.eventRepository = eventRepository
    self.bannerRepository = bannerRepository
  }

  func fetchHotPostList(
    challengeId: Int,
    completionHandler: @escaping (ApiResponse<[HotPost]>?) -> Void
  ) {
    self.hotPostRepository.requestHotPost(
      challengeId: challengeId,
      completionHandler: { response in
        completionHandler(response)
      }
    )
  }

  func fetchChallengeList(
    completionHandler: @escaping(ApiResponse<[ChallengeTitle]>?) -> Void
  ) {
    self.hotPostRepository.requestChallengeTitles(
      completionHandler: { response in
        completionHandler(response)
      }
    )
  }

  func fetchVerifiedStore() async -> ApiResponse<[Store]>? {
    return await self.verifiedStoreRepository.requestVerifiedStoreList()
  }

  func fetchEventList() async -> ApiResponse<[Event]>? {
    return await self.eventRepository.requestEventList()
  }

  func fetchBanner(bannerType: BannerType) async -> ApiResponse<[HomeBanner]>? {
    return await self.bannerRepository.requestBanner(bannerType: bannerType)
  }
}
