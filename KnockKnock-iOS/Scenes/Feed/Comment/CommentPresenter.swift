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
  func presentLoginStatus(isLoggedIn: Bool)

  func presentAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

final class CommentPresenter: CommentPresenterProtocol {
  var view: CommentViewProtocol?
  
  func presentVisibleComments(comments: [Comment]) {
    self.view?.fetchVisibleComments(comments: comments)
    LoadingIndicator.hideLoading()
  }

  func presentLoginStatus(isLoggedIn: Bool) {
    self.view?.setLoginStatus(isLoggedIn: isLoggedIn)
  }

  func presentAlert(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: (() -> Void)? = nil
  ) {
    self.view?.showAlertView(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}
