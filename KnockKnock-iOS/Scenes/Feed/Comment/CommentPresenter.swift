//
//  CommentPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import Foundation

protocol CommentPresenterProtocol {
  var view: CommentViewProtocol? { get set }
  
  func presentVisibleComments(allComments: [Comment])
  func presentDeleteComment()
}

final class CommentPresenter: CommentPresenterProtocol {
  var view: CommentViewProtocol?
  
  func presentDeleteComment() {
    self.view?.deleteComment()
  }
  
  func presentVisibleComments(allComments: [Comment]) {
    self.view?.fetchVisibleComments(comments: allComments)
    LoadingIndicator.hideLoading()
  }
}
