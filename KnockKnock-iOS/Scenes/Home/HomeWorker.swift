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
    completionHandler: @escaping ([HotPost]) -> Void
  )
  func fetchChallengeList(
    completionHandler: @escaping([ChallengeTitle]) -> Void
  )
  func fetchEventList() async -> [Event]
  func fetchBanner(bannerType: BannerType) async -> [HomeBanner]?
  func fetchVerifiedStore() async -> [Store]?
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
    completionHandler: @escaping ([HotPost]) -> Void
  ) {
    self.hotPostRepository.requestHotPost(
      challengeId: challengeId,
      completionHandler: { hotPostList in
        completionHandler(hotPostList)
      }
    )
  }

  func fetchChallengeList(
    completionHandler: @escaping([ChallengeTitle]) -> Void
  ) {
    self.hotPostRepository.requestChallengeTitles(
      completionHandler: { challengeList in
        completionHandler(challengeList)
      }
    )
  }

  func fetchVerifiedStore() async -> [Store]? {
    return await self.verifiedStoreRepository.requestVerifiedStoreList()
  }

  func fetchEventList() async -> [Event] {
    return await self.eventRepository.requestEventList()
  }

  func fetchBanner(bannerType: BannerType) async -> [HomeBanner]? {
    return await self.bannerRepository.requestBanner(bannerType: bannerType)
  }
}
