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
  
  func getComments(feedId: Int)
  func requestAddComment(comment: AddCommentRequest, completionHandler: @escaping ((String) -> Void))
}

final class CommentInteractor: CommentInteractorProtocol {
  var worker: CommentWorkerProtocol?
  var presenter: CommentPresenterProtocol?
  
  func getComments(feedId: Int) {
    self.worker?.getComments(
      feedId: feedId,
      completionHandler: { [weak self] comment in
        self?.presenter?.presentComments(comments: comment)
      }
    )
  }

  func requestAddComment(
    comment: AddCommentRequest,
    completionHandler: @escaping ((String) -> Void)
  ) {
    self.worker?.requestAddComment(
      comment: comment,
      completionHandler: { response in
        completionHandler(response)
      }
    )
  }
}
