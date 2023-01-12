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

  func fetchAllComments(feedId: Int)
  func toggleVisibleStatus(commentId: Int)

  func requestAddComment(comment: AddCommentRequest)
  func requestDeleteComment(commentId: Int)
  func fetchLikeList(feedId: Int)

  func navigateToLikeDetail(source: FeedDetailViewProtocol)
}

final class FeedDetailInteractor: FeedDetailInteractorProtocol {
  var worker: FeedDetailWorkerProtocol?
  var presenter: FeedDetailPresenterProtocol?
  var router: FeedDetailRouterProtocol?

  private var likeList: [Like.Info] = []

  /// 서버에서 받아온 전체 댓글 array
  var comments: [Comment] = []

  /// view에서 보여지는 댓글 array(open 상태 댓글만)
  var visibleComments: [Comment] = []

  // MARK: - Business logic

  func getFeedDeatil(feedId: Int) {
    self.worker?.getFeedDetail(
      feedId: feedId,
      completionHandler: { [weak self] feedDetail in
        self?.presenter?.presentFeedDetail(feedDetail: feedDetail)
      }
    )
  }

  func fetchLikeList(feedId: Int) {
    self.worker?.fetchLikeList(
      feedId: feedId,
      completionHandler: { [weak self] likeList in
        self?.likeList = likeList
        self?.presenter?.presentLike(like: likeList)
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

  /// 댓글 등록
  func requestAddComment(
    comment: AddCommentRequest
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
  // MARK: - Routing

  func navigateToLikeDetail(source: FeedDetailViewProtocol) {
    self.router?.navigateToLikeDetail(source: source, like: self.likeList)
  }
}
