//
//  FeedInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import Foundation

protocol FeedMainInteractorProtocol {
  var presenter: FeedMainPresenterProtocol? { get set }
  var worker: FeedMainWorkerProtocol? { get set }

  func fetchFeedMain(currentPage: Int, pageSize: Int, challengeId: Int)
  func fetchChallengeTitles()
  func setSelectedStatus(challengeTitles: [ChallengeTitle], selectedIndex: IndexPath)

  func saveSearchKeyword(searchKeyword: [SearchKeyword])
}

final class FeedMainInteractor: FeedMainInteractorProtocol {

  // MARK: - Properties
  
  var presenter: FeedMainPresenterProtocol?
  var worker: FeedMainWorkerProtocol?

  func saveSearchKeyword(searchKeyword: [SearchKeyword]) {
    self.worker?.saveSearchKeyword(searchKeyword: searchKeyword)
  }

  func fetchFeedMain(currentPage: Int, pageSize: Int, challengeId: Int) {
    self.worker?.fetchFeedMain(
      currentPage: currentPage,
      pageSize: pageSize,
      challengeId: challengeId,
      completionHandler: { [weak self] feed in
      self?.presenter?.presentFeedMain(feed: feed)
    })
  }

  func fetchChallengeTitles() {
    self.worker?.fetchChallengeTitles { [weak self] challengeTitle in
      var challengeTitle = challengeTitle
      challengeTitle[0].isSelected = true

      self?.presenter?.presentGetChallengeTitles(challengeTitle: challengeTitle, index: nil)
    }
  }

  func setSelectedStatus(challengeTitles: [ChallengeTitle], selectedIndex: IndexPath) {
    var challengeTitles = challengeTitles

    for index in 0..<challengeTitles.count {
      if index == selectedIndex.item {
        challengeTitles[index].isSelected = true
      } else {
        challengeTitles[index].isSelected = false
      }
    }
    presenter?.presentGetChallengeTitles(challengeTitle: challengeTitles, index: selectedIndex)
  }
}
