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

  func fetchFeed()
  func getChallengeTitles()
}

final class FeedInteractor: FeedInteractorProtocol {

  // MARK: - Properties
  
  var presenter: FeedPresenterProtocol?
  var worker: FeedWorkerProtocol?

  func fetchFeed() {
    self.worker?.fetchFeed { [weak self] feed in
      self?.presenter?.presentFetchFeed(feed: feed)
    }
  }

  func getChallengeTitles() {
    self.worker?.getChallengeTitles { [weak self] challengeTitle in
      var challengeTitle = challengeTitle
      challengeTitle[0].isSelected = true

      self?.presenter?.presentGetChallengeTitles(challengeTitle: challengeTitle)
    }
  }
}
