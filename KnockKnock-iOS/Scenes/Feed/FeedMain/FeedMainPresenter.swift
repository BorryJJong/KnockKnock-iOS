//
//  FeedPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import Foundation

protocol FeedMainPresenterProtocol {
  var view: FeedMainViewProtocol? { get set }
  
  func presentFeedMain(feed: FeedMain)
  func presentGetChallengeTitles(challengeTitle: [ChallengeTitle], index: IndexPath?)

}

final class FeedMainPresenter: FeedMainPresenterProtocol {

  // MARK: - Properties

  weak var view: FeedMainViewProtocol?

  func presentFeedMain(feed: FeedMain) {
    LoadingIndicator.hideLoading()
    self.view?.fetchFeedMain(feed: feed)
  }

  func presentGetChallengeTitles(challengeTitle: [ChallengeTitle], index: IndexPath?) {
    self.view?.fetchChallengeTitles(challengeTitle: challengeTitle, index: index)
  }
}
