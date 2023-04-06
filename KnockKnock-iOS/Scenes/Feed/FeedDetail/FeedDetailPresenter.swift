//
//  FeedDetailPresengitter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import Foundation

final class FeedDetailPresenter: FeedDetailPresenterProtocol {
  weak var view: FeedDetailViewProtocol?

  func presentFeedDetail(feedDetail: FeedDetail) {
    self.view?.getFeedDetail(feedDetail: feedDetail)
    LoadingIndicator.hideLoading()
  }

  func presentLikeList(like: [Like.Info]) {
    self.view?.fetchLikeList(like: like)
  }

  func presentLikeStatus(isToggle: Bool) {
    self.view?.fetchLikeStatus(isToggle: isToggle)
  }

  func presentDeleteComment() {
    self.view?.deleteComment()
  }

  func presentVisibleComments(comments: [Comment]) {
    self.view?.fetchVisibleComments(visibleComments: comments)
  }

  func presentAllCommentsCount(allCommentsCount: Int) {
    self.view?.getAllCommentsCount(allCommentsCount: allCommentsCount)
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
