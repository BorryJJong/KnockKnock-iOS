//
//  FeedPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import Foundation

protocol FeedPresenterProtocol {
  var view: FeedViewProtocol? { get set }
  
  func presentFetchFeed(feed: [Feed])
  func presentGetChallengeTitles(challengeTitle: [ChallengeTitle], index: IndexPath?)
}

final class FeedPresenter: FeedPresenterProtocol {

  // MARK: - Properties

  weak var view: FeedViewProtocol?

  func presentFetchFeed(feed: [Feed]) {
    self.view?.fetchFeed(feed: feed)
  }

  func presentGetChallengeTitles(challengeTitle: [ChallengeTitle], index: IndexPath?) {
    self.view?.getChallengeTitles(challengeTitle: challengeTitle, index: index)
  }
}
