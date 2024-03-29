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
  func presentGetChallengeTitles(
    challengeTitle: [ChallengeTitle],
    index: IndexPath?
  )
  func reloadFeedMain()

  func presentAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

final class FeedMainPresenter: FeedMainPresenterProtocol {

  // MARK: - Properties

  weak var view: FeedMainViewProtocol?

  func presentFeedMain(feed: FeedMain) {
    self.view?.fetchFeedMain(feed: feed)
    LoadingIndicator.hideLoading()
  }

  func presentGetChallengeTitles(
    challengeTitle: [ChallengeTitle],
    index: IndexPath?
  ) {
    self.view?.fetchChallengeTitles(
      challengeTitle: challengeTitle,
      index: index
    )
  }

  func reloadFeedMain() {
    self.view?.reloadFeedMain()
  }

  func presentAlert(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: (() -> Void)? = nil
  ) {
    self.view?.showAlertView(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}
