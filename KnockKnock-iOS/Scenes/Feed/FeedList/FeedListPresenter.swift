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
  func reloadFeedList()
  func presentDeleteFeed(feedId: Int)
  func presentLikeStatus(isToggle: Bool, indexPath: IndexPath)
}

final class FeedListPresenter: FeedListPresenterProtocol {
  var view: FeedListViewController?

  func presentFetchFeedList(feedList: FeedList) {
    self.view?.fetchFeedList(feedList: feedList)
    LoadingIndicator.hideLoading()
  }

  func reloadFeedList() {
    self.view?.reloadFeedList()
  }

  func presentDeleteFeed(feedId: Int) {
    self.view?.deleteFeedPost(feedId: feedId)
  }

  func presentLikeStatus(isToggle: Bool, indexPath: IndexPath) {
    self.view?.fetchLikeStatus(isToggle: isToggle, indexPath: indexPath)
  }
}
