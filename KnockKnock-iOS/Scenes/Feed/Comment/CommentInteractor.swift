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

  func getComments()
}

final class CommentInteractor: CommentInteractorProtocol {
  var worker: CommentWorkerProtocol?
  var presenter: CommentPresenterProtocol?

  func getComments() {
    self.worker?.getComments { [weak self] comment in
      self?.presenter?.presentComments(comments: comment)
    }
  }
}
