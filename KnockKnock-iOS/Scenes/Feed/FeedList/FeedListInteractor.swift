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
  
  func fetchFeedList(
    currentPage: Int,
    pageSize: Int,
    feedId: Int,
    challengeId: Int
  )
  func requestDelete(feedId: Int)

  func requestLike(feedId: Int, indexPath: IndexPath)
  func requestLikeCancel(feedId: Int, indexPath: IndexPath)

  func navigateToFeedMain()
  func navigateToFeedDetail(feedId: Int)
  func navigateToCommentView(feedId: Int)
  func presentBottomSheetView(isMyPost: Bool, deleteAction: (() -> Void)?)
}

final class FeedListInteractor: FeedListInteractorProtocol {
  var presenter: FeedListPresenterProtocol?
  var worker: FeedListWorkerProtocol?
  var router: FeedListRouterProtocol?

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
        self?.presenter?.presentFetchFeedList(feedList: feedList)
      }
    )
  }

  func requestDelete(feedId: Int) {
    self.worker?.requestDeleteFeed(
      feedId: feedId,
      completionHandler: { isSuccess in
        if isSuccess {
          self.presenter?.presentDeleteFeed(feedId: feedId)
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
}
