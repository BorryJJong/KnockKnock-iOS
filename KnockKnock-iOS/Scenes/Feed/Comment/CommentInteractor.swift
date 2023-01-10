//
//  CommentInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import Foundation

protocol CommentInteractorProtocol {
  var worker: CommentWorkerProtocol? { get set }
  var presenter: CommentPresenterProtocol? { get set }

  func fetchAllComments(feedId: Int)
  func fetchVisibleComments(comments: [Comment])
  func requestAddComment(comment: AddCommentDTO)
  func requestDeleteComment(commentId: Int)
}

final class CommentInteractor: CommentInteractorProtocol {
  var worker: CommentWorkerProtocol?
  var presenter: CommentPresenterProtocol?

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

  func requestAddComment(comment: AddCommentDTO) {
    self.worker?.requestAddComment(
      comment: comment,
      completionHandler: { success in
        if success {
          self.fetchAllComments(feedId: comment.postId)
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
}
