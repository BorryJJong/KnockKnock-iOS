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
  func presentLikeStatus(isToggle: Bool, indexPath: IndexPath)
  func toggleLikeButton(feedId: Int)
  func presentDeleteFeed(feedList: FeedList)
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

  func presentDeleteFeed(feedList: FeedList) {
    self.view?.deleteFeedPost(feedList: feedList)
  }

  func presentLikeStatus(isToggle: Bool, indexPath: IndexPath) {
    self.view?.fetchLikeStatus(isToggle: isToggle, indexPath: indexPath)
  }

  func toggleLikeButton(feedId: Int) {
    self.view?.toggleLikeButton(feedId: feedId)
  }
}
