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
  func getAllComments(feedId: Int)
  func setVisibleComments(comments: [Comment])
  func requestAddComment(feedId: Int, userId: Int, content: String, commentId: Int?)
  func getLike()
}

final class FeedDetailInteractor: FeedDetailInteractorProtocol {
  var worker: FeedDetailWorkerProtocol?
  var presenter: FeedDetailPresenterProtocol?

  func getFeedDeatil(feedId: Int) {
    self.worker?.getFeedDetail(
      feedId: feedId,
      complitionHandler: { [weak self] feedDetail in
        self?.presenter?.presentFeedDetail(feedDetail: feedDetail)
      })
  }

  func getLike() {
    self.worker?.getLike {[weak self] like in
      self?.presenter?.presentLike(like: like)
    }
  }

  func getAllComments(feedId: Int) {
    self.worker?.getAllComments(
      feedId: feedId,
      complitionHandler: { [weak self] comments in
        self?.presenter?.presentAllComments(allComments: comments)
      }
    )
  }

  func setVisibleComments(comments: [Comment]) {
    self.presenter?.setVisibleComments(allComments: comments)
  }
  
  func requestAddComment(
    feedId: Int,
    userId: Int,
    content: String,
    commentId: Int?
  ) {
    self.worker?.requestAddComment(
      feedId: feedId,
      userId: userId,
      content: content,
      commentId: commentId
    )
  }
}
