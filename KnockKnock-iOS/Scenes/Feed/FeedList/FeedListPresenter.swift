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
  func presentFeedLikeResult(isSuccess: Bool)
}

final class FeedListPresenter: FeedListPresenterProtocol {
  var view: FeedListViewController?

  func presentFetchFeedList(feedList: FeedList) {
    self.view?.fetchFeedList(feedList: feedList)
  }

  func presentFeedLikeResult(isSuccess: Bool) {
    self.view?.fetchFeedLikeResult(isSuccess: isSuccess)
  }
}
