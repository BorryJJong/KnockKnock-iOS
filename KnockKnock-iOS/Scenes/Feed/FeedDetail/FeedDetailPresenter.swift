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
  func presentVisibleComments(comments: [Comment])
  func presentLike(like: [Like.Info])

}

final class FeedDetailPresenter: FeedDetailPresenterProtocol {
  weak var view: FeedDetailViewProtocol?

  func presentFeedDetail(feedDetail: FeedDetail) {
    self.view?.getFeedDetail(feedDetail: feedDetail)
    LoadingIndicator.hideLoading()
  }

  func presentLike(like: [Like.Info]) {
    self.view?.fetchLikeList(like: like)
  }

  func presentVisibleComments(comments: [Comment]) {
    self.view?.fetchVisibleComments(visibleComments: comments)
  }

  func presentAllCommentsCount(allCommentsCount: Int) {
    self.view?.getAllCommentsCount(allCommentsCount: allCommentsCount)
  }
}
