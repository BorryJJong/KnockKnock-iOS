//
//  FeedListInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/26.
//

import Foundation

protocol FeedListInteractorProtocol {
  var presenter: FeedListPresenterProtocol? { get set }
  var worker: FeedListWorkerProtocol? { get set }

  func fetchFeedList(
    currentPage: Int,
    pageSize: Int,
    feedId: Int,
    challengeId: Int
  )

  func requestLike(feedId: Int)
  func requestLikeCancel(feedId: Int)
}

final class FeedListInteractor: FeedListInteractorProtocol {
  var presenter: FeedListPresenterProtocol?
  var worker: FeedListWorkerProtocol?

  func fetchFeedList(
    currentPage: Int,
    pageSize: Int,
    feedId: Int,
    challengeId: Int
  ) {
    LoadingIndicator.showLoading()
    
    self.worker?.fetchFeedList(
      currentPage: currentPage,
      count: pageSize,
      feedId: feedId,
      challengeId: challengeId,
      completionHandler: { [weak self] feedList in
        self?.presenter?.presentFetchFeedList(feedList: feedList)
      }
    )
  }

  func requestLike(feedId: Int) {
    self.worker?.requestLike(id: feedId, completionHandler: { result in
      self.presenter?.presentFeedLikeResult(isSuccess: result)
    })
  }

  func requestLikeCancel(feedId: Int) {
    self.worker?.requestLike(id: feedId, completionHandler: { result in
      self.presenter?.presentFeedLikeResult(isSuccess: result)
      print("isCanceled")
    })
  }
}
