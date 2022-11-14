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

  func getAllComments(feedId: Int)
  func setVisibleComments(comments: [Comment])
  func requestAddComment(comment: AddCommentRequest)

}

final class CommentInteractor: CommentInteractorProtocol {
  var worker: CommentWorkerProtocol?
  var presenter: CommentPresenterProtocol?

  func getAllComments(feedId: Int) {
    self.worker?.getAllComments(
      feedId: feedId,
      completionHandler: { [weak self] comments in
        self?.presenter?.presentAllComments(allComments: comments)
      }
    )
  }

  func setVisibleComments(comments: [Comment]) {
    self.presenter?.setVisibleComments(allComments: comments)
  }

  func requestAddComment(comment: AddCommentRequest) {
    self.worker?.requestAddComment(
      comment: comment,
      completionHandler: { response in
        if response == "success" {
          self.getAllComments(feedId: comment.feedId)
        }
      }
    )
  }
}
