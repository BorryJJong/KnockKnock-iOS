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
  var router: FeedListRouterProtocol? { get set }
  
  func fetchFeedList(currentPage: Int, pageSize: Int, feedId: Int, challengeId: Int)
  func requestDelete(feedId: Int)

  func requestLike(feedId: Int)
  func requestLikeCancel(feedId: Int)

  func presentBottomSheetView(isMyPost: Bool, deleteAction: (() -> Void)?, feedData: FeedList.Post)
  func navigateToFeedMain()
  func navigateToFeedDetail(feedId: Int)
  func navigateToCommentView(feedId: Int)

  func setNotification()

}

final class FeedListInteractor: FeedListInteractorProtocol {
  var presenter: FeedListPresenterProtocol?
  var worker: FeedListWorkerProtocol?
  var router: FeedListRouterProtocol?

  var feedListData: FeedList?

  // Business Logic

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

        if currentPage == 1 {
          self?.feedListData = feedList
        } else {
          self?.feedListData?.feeds += feedList.feeds
        }

        guard let feedListData = self?.feedListData else { return }
        self?.presenter?.presentFetchFeedList(feedList: feedListData)
      }
    )
  }

  func requestDelete(feedId: Int) {

    self.worker?.requestDeleteFeed(
      feedId: feedId,
      completionHandler: { isSuccess in

        if isSuccess {
          if let feedIndex = self.feedListData?.feeds.firstIndex(where: {
            $0.id == feedId
          }) {
            self.feedListData?.feeds.remove(at: feedIndex)
          }

          guard let feedListData = self.feedListData else { return }
          self.presenter?.presentFetchFeedList(feedList: feedListData)

        } else {
          print(isSuccess) // error
        }
      }
    )
  }

  func toggleLike(feedId: Int) {

    self.feedListData?.toggleIsLike(feedId: feedId)

    guard let feedListData = self.feedListData else { return }
    self.presenter?.presentFetchFeedList(feedList: feedListData)
  }

  func requestLike(feedId: Int) {
    guard let isExistedUser = self.worker?.checkTokenExisted() else { return }

    if isExistedUser {
      self.worker?.requestLike(
        feedId: feedId,
        completionHandler: { result in
          if result {
            self.toggleLike(feedId: feedId)
          } else {
            // error
          }
        }
      )
    } else {
      self.router?.navigateToLoginView()
    }
  }
  
  func requestLikeCancel(feedId: Int) {
    guard let isExistedUser = self.worker?.checkTokenExisted() else { return }

    if isExistedUser {
      self.worker?.requestLikeCancel(
        feedId: feedId,
        completionHandler: {  result in
          if result {
            self.toggleLike(feedId: feedId)
          } else {
            // error
          }
        }
      )
    } else {
      self.router?.navigateToLoginView()
    }
  }

  // Routing

  func navigateToFeedDetail(feedId: Int) {
    self.router?.navigateToFeedDetail(feedId: feedId)
  }

  func navigateToCommentView(feedId: Int) {
    self.router?.navigateToCommentView(feedId: feedId)
  }

  func navigateToFeedMain() {
    self.router?.navigateToFeedMain()
  }

  func presentBottomSheetView(
    isMyPost: Bool,
    deleteAction: (() -> Void)?,
    feedData: FeedList.Post
  ) {
    self.router?.presentBottomSheetView(
      isMyPost: isMyPost,
      deleteAction: deleteAction,
      feedData: feedData.toShare()
    )
  }

  // Notification Center

  func setNotification() {
    NotificationCenter.default.addObserver(
      forName: .feedRefreshAfterSigned,
      object: nil,
      queue: nil
    ) { _ in
      self.presenter?.reloadFeedList()
    }

    NotificationCenter.default.addObserver(
      forName: .feedRefreshAfterUnsigned,
      object: nil,
      queue: nil
    ) { _ in
      self.presenter?.reloadFeedList()
    }

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.getFeedId(_:)),
      name: .postLike,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.getFeedId(_:)),
      name: .postLikeCancel,
      object: nil
    )
  }

  @objc private func getFeedId(_ notification: Notification) {
    guard let feedId = notification.object as? Int else { return }
    self.toggleLike(feedId: feedId)
  }
}
