//
//  FeedDetailInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import UIKit

protocol FeedDetailInteractorProtocol {
  var worker: FeedDetailWorkerProtocol? { get set }
  var presenter: FeedDetailPresenterProtocol? { get set }
  var router: FeedDetailRouterProtocol? { get set }
  
  func getFeedDeatil(feedId: Int)
  func requestDelete(feedId: Int)
  func requestHide(feedId: Int)

  func fetchAllComments(feedId: Int)

  func fetchVisibleComments(comments: [Comment])
  func requestAddComment(comment: AddCommentDTO)
  func toggleVisibleStatus(commentId: Int)
  func requestDeleteComment(commentId: Int)
  
  func requestLike(feedId: Int)
  func fetchLikeList(feedId: Int)
  
  func navigateToLikeDetail()
  func presentBottomSheetView(
    isMyPost: Bool,
    deleteAction: (() -> Void)?,
    hideAction: (() -> Void)?,
    editAction: (() -> Void)?
  )
  func navigateToFeedEdit(feedId: Int)
}

final class FeedDetailInteractor: FeedDetailInteractorProtocol {
  var worker: FeedDetailWorkerProtocol?
  var presenter: FeedDetailPresenterProtocol?
  var router: FeedDetailRouterProtocol?
  
  private var likeList: [Like.Info] = []

  /// 서버에서 받아온 전체 댓글 array
  private var comments: [Comment] = []

  /// view에서 보여지는 댓글 array(open 상태 댓글만)
  private var visibleComments: [Comment] = []

  private var feedDetail: FeedDetail?

  // MARK: - Initialize

  init() {
    self.setNotification()
  }

  // MARK: - Business logic

  func getFeedDeatil(feedId: Int) {
    self.worker?.getFeedDetail(
      feedId: feedId,
      completionHandler: { [weak self] feedDetail in
        self?.feedDetail = feedDetail
        self?.presenter?.presentFeedDetail(feedDetail: feedDetail)
      }
    )
  }
  
  func requestLike(feedId: Int) {
    
    // 비로그인 유저인 경우 로그인 화면으로 이동
    guard self.worker?.checkTokenExisted() ?? false else {
      self.router?.navigateToLoginView()
      return
    }

    // 좋아요 이벤트 실행한 피드의 좋아요 여부
    guard let isLike = self.feedDetail?.feed?.isLike else { return }

    self.worker?.requestLike(
      isLike: isLike,
      feedId: feedId,
      completionHandler: { [weak self] isSuccess in
        guard let self = self else { return }
        guard isSuccess else {
          // error handle
          return
        }
        self.feedDetail = self.worker?.toggleLike(feedDetail: self.feedDetail)

        self.presenter?.presentLikeStatus(isToggle: isSuccess)
        self.fetchLikeList(feedId: feedId)
      }
    )
  }
  
  func fetchLikeList(feedId: Int) {
    self.worker?.fetchLikeList(
      feedId: feedId,
      completionHandler: { [weak self] likeList in
        self?.likeList = likeList
        self?.presenter?.presentLikeList(like: likeList)
      }
    )
  }

  /// 댓글 목록 조회 api로부터 받은 전체 댓글 fetch
  func fetchAllComments(feedId: Int) {
    self.worker?.getAllComments(
      feedId: feedId,
      completionHandler: { [weak self] comments in
        self?.comments = comments
        self?.visibleComments = self?.worker?.fetchVisibleComments(comments: self?.comments) ?? []
        self?.presenter?.presentVisibleComments(comments: self?.visibleComments ?? [])
      }
    )
  }

  /// 답글 펼침/숨김 상태 toggle
  func toggleVisibleStatus(commentId: Int) {
    guard let index = self.comments.firstIndex(where: {
      $0.data.id == commentId
    }) else { return }
    
    self.comments[index].isOpen.toggle()

    self.visibleComments = self.worker?.fetchVisibleComments(comments: self.comments) ?? []
    self.presenter?.presentVisibleComments(comments: self.visibleComments)
  }

  /// 답글을 포함한 모든 댓글의 수 (헤더에 표기)
  func fetchAllCommentsCount(comments: [Comment]) {
    var count = comments.count
    
    comments.forEach {
      count += $0.data.reply?.count ?? 0
    }
    self.presenter?.presentAllCommentsCount(allCommentsCount: count)
  }
  
  /// 비숨김 처리 댓글 fetch
  /// 매번 모든 댓글을 받아오지 않도록 별도 정의
  func fetchVisibleComments(comments: [Comment]) {
    self.presenter?.presentVisibleComments(comments: comments)
  }

  /// 댓글 등록
  func requestAddComment(
    comment: AddCommentDTO
  ) {
    self.worker?.requestAddComment(
      comment: comment,
      completionHandler: { success in
        if success {
          self.fetchAllComments(feedId: comment.postId)
        }
      }
    )
  }

  /// 댓글 삭제
  func requestDeleteComment(commentId: Int) {
    self.worker?.requestDeleteComment(
      commentId: commentId,
      completionHandler: {

        if let index = self.comments.firstIndex(where: { $0.data.id == commentId }) {
          self.comments[index].data.isDeleted = true
        }

        for commentIndex in 0..<self.comments.count {
          if let replyIndex = self.comments[commentIndex].data.reply?.firstIndex(where: {
            $0.id == commentId
          }) {
            self.comments[commentIndex].data.reply?[replyIndex].isDeleted = true
          }
        }

        self.visibleComments = self.worker?.fetchVisibleComments(comments: self.comments) ?? []
        self.presenter?.presentVisibleComments(comments: self.visibleComments)
      }
    )
  }

  /// 피드 삭제
  func requestDelete(feedId: Int) {

    self.worker?.requestDeleteFeed(
      feedId: feedId,
      completionHandler: { isSuccess in
        if isSuccess {
          self.showAlertView(
            message: "게시글이 삭제되었습니다.",
            confirmAction: {
              self.navigateToFeedList()
            }
          )
        } else {
          self.showAlertView(
            message: "게시글 삭제에 실패하였습니다.",
            confirmAction: nil
          )
        }
      }
    )
  }

  /// 피드 숨기기
  ///
  func requestHide(feedId: Int) {

    self.worker?.requestHidePost(
      feedId: feedId,
      completionHandler: { isSuccess in

        if isSuccess {
          self.showAlertView(
            message: "게시글이 숨김 처리 되었습니다.",
            confirmAction: {
              self.navigateToFeedList()
            }
          )
        } else {
          self.showAlertView(
            message: "게시글 숨김 처리에 실패하였습니다.",
            confirmAction: nil
          )
        }
      }
    )
  }

  // Routing
  
  func navigateToLikeDetail() {
    self.router?.navigateToLikeDetail(like: self.likeList)
  }

  func navigateToFeedList() {
    self.router?.navigateToFeedList()
  }

  func navigateToFeedEdit(feedId: Int) {
    self.router?.navigateToFeedEdit(feedId: feedId)
  }

  func presentBottomSheetView(
    isMyPost: Bool,
    deleteAction: (() -> Void)?,
    hideAction: (() -> Void)?,
    editAction: (() -> Void)?
  ) {
    self.router?.presentBottomSheetView(
      isMyPost: isMyPost,
      deleteAction: deleteAction,
      hideAction: hideAction,
      editAction: editAction
    )
  }

  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  ) {
    self.router?.showAlertView(
      message: message,
      confirmAction: confirmAction
    )
  }
}

extension FeedDetailInteractor {

  /// 수정 된 피드 refetch
  @objc
  private func editNotificationEvent(_ notification: Notification) {
    guard let feedId = notification.object as? Int else { return }
    self.getFeedDeatil(feedId: feedId)
  }

  private func setNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.editNotificationEvent(_:)),
      name: .feedDetailRefreshAfterEdited,
      object: nil
    )
  }
}
