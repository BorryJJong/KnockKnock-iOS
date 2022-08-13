//
//  FeedInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import Foundation

protocol FeedInteractorProtocol {
  var presenter: FeedPresenterProtocol? { get set }
  var worker: FeedWorkerProtocol? { get set }

  func getFeedMain(currentPage: Int, totalCount: Int, challengeId: Int)
  func getChallengeTitles()
  func setSelectedStatus(challengeTitles: [ChallengeTitle], selectedIndex: IndexPath)
}

final class FeedInteractor: FeedInteractorProtocol {

  // MARK: - Properties
  
  var presenter: FeedPresenterProtocol?
  var worker: FeedWorkerProtocol?

//  func fetchFeed() {
//    self.worker?.fetchFeed { [weak self] feed in
//      self?.presenter?.presentFetchFeed(feed: feed)
//    }
//  }
  func getFeedMain(currentPage: Int, totalCount: Int, challengeId: Int) {
    self.worker?.getFeedMain(
      currentPage: currentPage,
      totalCount: totalCount,
      challengeId: challengeId,
      completionHandler:  { [weak self] feed in
      self?.presenter?.presentFeedMain(feed: feed)
    })
  }

  func getChallengeTitles() {
    self.worker?.getChallengeTitles { [weak self] challengeTitle in
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
