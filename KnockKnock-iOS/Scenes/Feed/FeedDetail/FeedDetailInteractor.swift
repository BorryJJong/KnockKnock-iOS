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

  func getFeedDeatil(feedId: Int)
  func fetchAllComments(feedId: Int)
  func fetchVisibleComments(comments: [Comment])
  func requestAddComment(comment: AddCommentRequest)
  func getLike()
}

final class FeedDetailInteractor: FeedDetailInteractorProtocol {
  var worker: FeedDetailWorkerProtocol?
  var presenter: FeedDetailPresenterProtocol?

  func getFeedDeatil(feedId: Int) {
    self.worker?.getFeedDetail(
      feedId: feedId,
      completionHandler: { [weak self] feedDetail in
        self?.presenter?.presentFeedDetail(feedDetail: feedDetail)
      })
  }

  func getLike() {
    self.worker?.fetchLike(
      completionHandler: { [weak self] like in
      self?.presenter?.presentLike(like: like)
    })
  }

  func fetchAllComments(feedId: Int) {
    self.worker?.getAllComments(
      feedId: feedId,
      completionHandler: { [weak self] comments in
        self?.fetchVisibleComments(comments: comments)
      }
    )
  }

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
}
