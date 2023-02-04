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

  func presentBottomSheetView(isMyPost: Bool, deleteAction: (() -> Void)?, feedData: FeedList.Post)
  func navigateToFeedMain()
  func navigateToFeedDetail(feedId: Int)
  func navigateToCommentView(feedId: Int)
}

final class FeedListInteractor: FeedListInteractorProtocol {
  var presenter: FeedListPresenterProtocol?
  var worker: FeedListWorkerProtocol?
  var router: FeedListRouterProtocol?
  
  var feedListData: FeedList?
  
  // MARK: - Initialize
  
  init() {
    self.setNotification()
  }
  
  // MARK: - Business Logic
  
  /// 피드 리스트 조회
  ///
  /// - Parameters:
  ///   - currentPage: 현재 페이지
  ///   - pageSize: 페이지 사이즈
  ///   - feedId: 피드 아이디
  ///   - challengeId: 챌린지 아이디
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
  
  /// 피드 삭제
  ///
  /// - Parameters:
  ///   - feedId: 피드 아이디
  func requestDelete(feedId: Int) {
    
    guard let feedList = self.feedListData else { return }
    guard !feedList.feeds.isEmpty else { return }
    
    // 삭제 요청한 피드가 현재 존재하는지 피드인지 체크
    guard feedList.feeds.contains(where: { feedId == $0.id }) else { return }
    
    self.worker?.requestDeleteFeed(
      feedId: feedId,
      completionHandler: { isSuccess in
        
        if isSuccess {

          self.deletePost(
            feedList: feedList,
            feedId: feedId
          )
          
        } else {
          print(isSuccess) // error
        }
      }
    )
  }
  
  /// 피드 좋아요
  ///
  /// - Parameters:
  ///   - feedId: 피드 아이디
  func requestLike(feedId: Int) {
    
    // 비로그인 유저인 경우 로그인 화면으로 이동
    guard self.worker?.checkTokenExisted() ?? false else {
      self.router?.navigateToLoginView()
      return
    }
    
    guard let feedList = self.feedListData?.feeds else { return }
    guard !feedList.isEmpty else { return }
    
    // 좋아요 누른 피드가 현재 존재하는지 피드인지 체크
    guard feedList.contains(where: { feedId == $0.id }) else { return }
    
    // 좋아요 이벤트 실행한 피드의 좋아요 여부
    guard let isLike = self.worker?.checkCurrentLikeState(
      feedList: feedList,
      feedId: feedId
    ) else {
      return
    }
    
    self.worker?.requestLike(
      isLike: isLike,
      feedId: feedId,
      completionHandler: { [weak self] isSuccess in
        guard let self = self else { return }
        guard isSuccess else {
          // error handle
          return
        }
        
        self.toggleLike(feedId: feedId)
      }
    )
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
}

// MARK: - Inner Actions

extension FeedListInteractor {
  
  /// 피드 상세에서 발생한 좋아요 이벤트 반영
  @objc
  private func likeNotificationEvent(_ notification: Notification) {
    guard let feedId = notification.object as? Int else { return }
    self.toggleLike(feedId: feedId)
  }

  /// 피드 상세에서 발생한 삭제 이벤트 반영
  @objc
  private func deleteNotificationEvent(_ notification: Notification) {
    guard let feedId = notification.object as? Int else { return }

    guard let feedList = self.feedListData else { return }
    guard !feedList.feeds.isEmpty else { return }

    // 삭제 요청한 피드가 현재 존재하는지 피드인지 체크
    guard feedList.feeds.contains(where: { feedId == $0.id }) else { return }

    self.deletePost(feedList: feedList, feedId: feedId)
  }
  
  /// Toggle Like
  private func toggleLike(feedId: Int) {
    
    guard let feedListData = self.feedListData else { return }
    guard !feedListData.feeds.isEmpty else { return }
    
    guard let convertFeedList = self.worker?.convertLikeFeed(
      feeds: feedListData,
      id: feedId
    ) else {
      return
    }
    
    self.feedListData = convertFeedList
    
    let updatedSections: [IndexPath] = self.worker?.changedSections(
      feeds: feedListData.feeds,
      id: feedId
    )
      .map { IndexPath(item: 0, section: $0) } ?? []
    
    self.presenter?.presentUpdateFeedList(
      feedList: convertFeedList,
      sections: updatedSections
    )
  }

  private func deletePost(
    feedList: FeedList,
    feedId: Int
  ) {
    // 피드 리스트 내 해당 게시글 모두 삭제
    guard let feedListData = self.worker?.removePostInFeedList(
      feeds: feedList,
      id: feedId
    ) else { return }

    self.presenter?.presentFetchFeedList(feedList: feedListData)
  }
  
  // Notification Center
  
  private func setNotification() {
    NotificationCenter.default.addObserver(
      forName: .feedListRefreshAfterSigned,
      object: nil,
      queue: nil
    ) { _ in
      self.presenter?.reloadFeedList()
    }
    
    NotificationCenter.default.addObserver(
      forName: .feedListRefreshAfterUnsigned,
      object: nil,
      queue: nil
    ) { _ in
      self.presenter?.reloadFeedList()
    }
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.likeNotificationEvent(_:)),
      name: .postLikeToggled,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.deleteNotificationEvent(_:)),
      name: .feedListRefreshAfterDelete,
      object: nil
    )

    NotificationCenter.default.addObserver(
      forName: .feedListRefreshAfterWrite,
      object: nil,
      queue: nil
    ) { _ in
      self.presenter?.reloadFeedList()
    }
  }
}
