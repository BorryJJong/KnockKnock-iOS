//
//  CommentPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import Foundation

protocol CommentPresenterProtocol {
  var view: CommentViewProtocol? { get set }
  
  func presentVisibleComments(comments: [Comment])
}

final class CommentPresenter: CommentPresenterProtocol {
  var view: CommentViewProtocol?
  
  func presentVisibleComments(comments: [Comment]) {
    self.view?.fetchVisibleComments(comments: comments)
    LoadingIndicator.hideLoading()
  }
}
