//
//  FeedPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/26.
//

import UIKit

protocol FeedListPresenterProtocol {
  var view: FeedListViewController? { get set }
  func presentFetchFeedList(feed: [Feed])
}

final class FeedListPresenter: FeedListPresenterProtocol {
  var view: FeedListViewController?

  func presentFetchFeedList(feed: [Feed]) {
    self.view?.fetchFeedList(feed: feed)
  }
}
