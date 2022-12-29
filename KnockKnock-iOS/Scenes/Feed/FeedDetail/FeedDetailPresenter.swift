//
//  FeedDetailPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import UIKit

protocol FeedDetailPresenterProtocol {
  var view: FeedDetailViewProtocol? { get set }

  func presentFeedDetail(feedDetail: FeedDetail)
  func presentAllCommentsCount(allCommentsCount: Int)
  func presentVisibleComments(allComments: [Comment])
  func presentDeleteComment()
  func presentLike(like: [LikeInfo])
}

final class FeedDetailPresenter: FeedDetailPresenterProtocol {
  weak var view: FeedDetailViewProtocol?

  func presentFeedDetail(feedDetail: FeedDetail) {
    self.view?.getFeedDetail(feedDetail: feedDetail)
    LoadingIndicator.hideLoading()
  }

  func presentLike(like: [LikeInfo]) {
    self.view?.fetchLikeList(like: like)
  }

  func presentDeleteComment() {
    self.view?.deleteComment()
  }

  func presentVisibleComments(allComments: [Comment]) {
    self.view?.fetchVisibleComments(visibleComments: allComments)
  }

  func presentAllCommentsCount(allCommentsCount: Int) {
    self.view?.getAllCommentsCount(allCommentsCount: allCommentsCount)
  }
}
