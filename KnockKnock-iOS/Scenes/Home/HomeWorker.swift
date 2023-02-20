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

}

final class HomeWorker: HomeWorkerProtocol {

  private let hotPostRepository: HotPostRepositoryProtocol
  private let eventRepository: EventRepositoryProtocol

  init(
    hotPostRepository: HotPostRepositoryProtocol,
    eventRepository: EventRepositoryProtocol
  ) {
    self.hotPostRepository = hotPostRepository
    self.eventRepository = eventRepository
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

  func fetchEventList() async -> [Event] {
    return await self.eventRepository.requestEventList()
  }
}
