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

  func getAllComments()
  func setVisibleComments(comments: [Comment])
}

final class CommentInteractor: CommentInteractorProtocol {
  var worker: CommentWorkerProtocol?
  var presenter: CommentPresenterProtocol?

  func getAllComments() {
    self.worker?.getAllComments(completionHandler: {[weak self] comments in
      self?.presenter?.presentAllComments(allComments: comments)
    })
  }

  func setVisibleComments(comments: [Comment]) {
    self.presenter?.setVisibleComments(visibleComments: comments)
  }
}
