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
  func fetchVisibleComments(comments: [Comment])
  func requestAddComment(comment: AddCommentRequest)
  func requestDeleteComment(commentId: Int)
  func fetchLikeList(feedId: Int)

  func navigateToLikeDetail(source: FeedDetailViewProtocol)
}

final class FeedDetailInteractor: FeedDetailInteractorProtocol {
  var worker: FeedDetailWorkerProtocol?
  var presenter: FeedDetailPresenterProtocol?
  var router: FeedDetailRouterProtocol?

  private var likeList: [LikeInfo] = []

  // Business logic

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

  /// 전체 댓글 data fetch
  func fetchAllComments(feedId: Int) {
    self.worker?.getAllComments(
      feedId: feedId,
      completionHandler: { [weak self] comments in
        self?.fetchAllCommentsCount(comments: comments)
        self?.fetchVisibleComments(comments: comments)
      }
    )
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
    self.presenter?.presentVisibleComments(allComments: comments)
  }
  
  func requestAddComment(
    comment: AddCommentRequest
  ) {
    self.worker?.requestAddComment(
      comment: comment,
      completionHandler: { response in
        if response == "success" {
          self.fetchAllComments(feedId: comment.feedId)
        }
      }
    )
  }

  func requestDeleteComment(commentId: Int) {
    self.worker?.requestDeleteComment(
      commentId: commentId,
      completionHandler: {
        self.presenter?.presentDeleteComment()
      }
    )
  }

  // Routing

  func navigateToLikeDetail(source: FeedDetailViewProtocol) {
    self.router?.navigateToLikeDetail(source: source, like: self.likeList)
  }
}
