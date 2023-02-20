//
//  HomeWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/23.
//

import UIKit

protocol HomeWorkerProtocol {
  func fetchHotPostList(
    challengeId: Int,
    completionHandler: @escaping ([HotPost]) -> Void
  )
  func fetchChallengeList(completionHandler: @escaping([ChallengeTitle]) -> Void)
  func fetchEventList() async -> [Event]
  func fetchVerifiedStore() async -> [Store]?
}

final class HomeWorker: HomeWorkerProtocol {

  private let homeRepository: HomeRepositoryProtocol

  init(homeRepository: HomeRepositoryProtocol) {
    self.homeRepository = homeRepository
  }

  func fetchHotPostList(
    challengeId: Int,
    completionHandler: @escaping ([HotPost]) -> Void
  ) {
    self.homeRepository.requestHotPost(
      challengeId: challengeId,
      completionHandler: { hotPostList in
        completionHandler(hotPostList)
      }
    )
  }

  func fetchChallengeList(completionHandler: @escaping([ChallengeTitle]) -> Void) {
    self.homeRepository.requestChallengeTitles(
      completionHandler: { challengeList in
      completionHandler(challengeList)
    }
    )
  }

  func fetchVerifiedStore() async -> [Store]? {
    return await self.homeRepository.requestVerifiedStoreList()
  }

  func fetchEventList() async -> [Event] {
    return await self.homeRepository.requestEventList()
  }
}
