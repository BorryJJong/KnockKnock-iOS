//
//  FeedPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/26.
//

import Foundation

final class FeedListPresenter: FeedListPresenterProtocol {
  var view: FeedListViewController?

  func presentFetchFeedList(feedList: FeedList) {
    self.view?.fetchFeedList(feedList: feedList)
    LoadingIndicator.hideLoading()
  }

  func presentUpdateFeedList(
    feedList: FeedList,
    sections: [IndexPath]
  ) {
    self.view?.updateFeedList(
      feedList: feedList,
      sections: sections
    )
    LoadingIndicator.hideLoading()
  }

  func reloadFeedList() {
    self.view?.reloadFeedList()
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
