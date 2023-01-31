//
//  FeedPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/26.
//

import UIKit

protocol FeedListPresenterProtocol {
  var view: FeedListViewController? { get set }

  func presentFetchFeedList(feedList: FeedList)
  func presentUpdateFeedList(feedList: FeedList, sections: [IndexPath])
  func reloadFeedList()
}

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
}
