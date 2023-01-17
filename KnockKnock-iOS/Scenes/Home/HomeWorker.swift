//
//  HomeWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/23.
//

import UIKit

protocol HomeWorkerProtocol {
  func fetchHotPostList(completionHandler: @escaping ([HotPost]) -> Void)
  func fetchChallengeList(completionHandler: @escaping([ChallengeTitle]) -> Void)
}

final class HomeWorker: HomeWorkerProtocol {

  private let homeRepository: HomeRepositoryProtocol

  init(homeRepository: HomeRepositoryProtocol) {
    self.homeRepository = homeRepository
  }

  func fetchHotPostList(completionHandler: @escaping ([HotPost]) -> Void) {
    self.homeRepository.requestHotPost(completionHandler: { hotPostList in
      completionHandler(hotPostList)
    })
  }

  func fetchChallengeList(completionHandler: @escaping([ChallengeTitle]) -> Void) {
    self.homeRepository.requestChallengeTitles(completionHandler: { challengeList in
      completionHandler(challengeList)
    })
  }
}
