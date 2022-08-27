//
//  FeedPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import Foundation

protocol FeedPresenterProtocol {
  var view: FeedViewProtocol? { get set }
  
  func presentFeedMain(feed: FeedMain)
  func presentGetChallengeTitles(challengeTitle: [ChallengeTitle], index: IndexPath?)
}

final class FeedPresenter: FeedPresenterProtocol {

  // MARK: - Properties

  weak var view: FeedViewProtocol?

  func presentFeedMain(feed: FeedMain) {
    self.view?.requestFeedMain(feed: feed)
  }

  func presentGetChallengeTitles(challengeTitle: [ChallengeTitle], index: IndexPath?) {
    self.view?.requestChallengeTitles(challengeTitle: challengeTitle, index: index)
  }
}
