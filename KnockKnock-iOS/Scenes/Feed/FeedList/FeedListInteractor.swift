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

  func requestLike(feedId: Int, indexPath: IndexPath)
  func requestLikeCancel(feedId: Int, indexPath: IndexPath)

  func navigateToFeedMain()
  func navigateToFeedDetail(feedId: Int)
  func navigateToCommentView(feedId: Int)
  func presentBottomSheetView(isMyPost: Bool, deleteAction: (() -> Void)?)

  func setNotification()
}

final class FeedListInteractor: FeedListInteractorProtocol {
  var presenter: FeedListPresenterProtocol?
  var worker: FeedListWorkerProtocol?
  var router: FeedListRouterProtocol?

  var postList: FeedList?

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
          self?.postList = feedList
        } else {
          self?.postList?.feeds += feedList.feeds
        }

        guard let postList = self?.postList else { return }

        self?.presenter?.presentFetchFeedList(feedList: postList)
      }
    )
  }

  func requestDelete(feedId: Int) {

    self.worker?.requestDeleteFeed(
      feedId: feedId,
      completionHandler: { isSuccess in

        if isSuccess {

          if let feedIndex = self.postList?.feeds.firstIndex(where: {
            $0.id == feedId
          }) {
            self.postList?.feeds.remove(at: feedIndex)
          }

          guard let postList = self.postList else { return }

          self.presenter?.presentDeleteFeed(feedList: postList)

        } else {
          print(isSuccess)
        }
      }
    )
  }

  func requestLike(feedId: Int, indexPath: IndexPath) {
    self.worker?.checkTokenExisted(completionHandler: { isExisted in
      if isExisted {
        self.worker?.requestLike(
          feedId: feedId,
          completionHandler: { result in
            if result {
              self.presenter?.presentLikeStatus(isToggle: isExisted, indexPath: indexPath)
            } else {
              // error
            }
          }
        )
      } else {
        self.router?.navigateToLoginView()
        self.presenter?.presentLikeStatus(isToggle: isExisted, indexPath: indexPath)
      }
    })
  }
  
  func requestLikeCancel(feedId: Int, indexPath: IndexPath) {
    self.worker?.checkTokenExisted(completionHandler: { isExisted in
      if isExisted {
        
        self.worker?.requestLikeCancel(
          feedId: feedId,
          completionHandler: {  result in
            if result {
              self.presenter?.presentLikeStatus(isToggle: isExisted, indexPath: indexPath)
            } else {
              // error
            }
          }
        )
      } else {
        self.router?.navigateToLoginView()
        self.presenter?.presentLikeStatus(isToggle: isExisted, indexPath: indexPath)
      }
    })
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
    deleteAction: (() -> Void)?
  ) {
    self.router?.presentBottomSheetView(
      isMyPost: isMyPost,
      deleteAction: deleteAction
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
    self.presenter?.toggleLikeButton(feedId: feedId)
  }
}
