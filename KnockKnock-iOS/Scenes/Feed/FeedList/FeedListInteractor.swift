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

  func requestLike(source: FeedListViewProtocol, feedId: Int)
  func requestLikeCancel(source: FeedListViewProtocol, feedId: Int)

  func navigateToFeedMain(source: FeedListViewProtocol)
  func navigateToFeedDetail(source: FeedListViewProtocol, feedId: Int)
  func navigateToCommentView(feedId: Int, source: FeedListViewProtocol)
  func presentBottomSheetView(source: FeedListViewProtocol, isMyPost: Bool, deleteAction: (() -> Void)?)
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

  func requestLike(source: FeedListViewProtocol, feedId: Int) {
    self.worker?.checkTokenExisted(completionHandler: { isExisted in
      if isExisted {
        self.worker?.requestLike(
          id: feedId,
          completionHandler: { result in
            print(result) // 추후 error 처리
          }
        )
      } else {
        self.router?.navigateToLoginView(source: source)
      }
    })
  }
  
  func requestLikeCancel(source: FeedListViewProtocol, feedId: Int) {
    self.worker?.checkTokenExisted(completionHandler: { isExisted in
      if isExisted {
        
        self.worker?.requestLikeCancel(
          id: feedId,
          completionHandler: { result in
            print(result) // 추후 error 처리
          }
        )
      } else {
        self.router?.navigateToLoginView(source: source)
      }
    })
  }

  // Routing

  func navigateToFeedDetail(
    source: FeedListViewProtocol,
    feedId: Int
  ) {
    self.router?.navigateToFeedDetail(
      source: source,
      feedId: feedId
    )
  }

  func navigateToCommentView(
    feedId: Int,
    source: FeedListViewProtocol
  ) {
    self.router?.navigateToCommentView(
      feedId: feedId,
      source: source
    )
  }

  func navigateToFeedMain(source: FeedListViewProtocol) {
    self.router?.navigateToFeedMain(source: source)
  }

  func presentBottomSheetView(
    source: FeedListViewProtocol,
    isMyPost: Bool,
    deleteAction: (() -> Void)?
  ) {
    self.router?.presentBottomSheetView(
      source: source,
      isMyPost: isMyPost,
      deleteAction: deleteAction
    )
  }
}
