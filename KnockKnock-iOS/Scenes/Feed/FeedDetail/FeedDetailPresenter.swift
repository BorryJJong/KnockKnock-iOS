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
  func presentDeleteComment(commentId: Int)
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

  func presentDeleteComment(commentId: Int) {
    self.view?.deleteComment(commentId: commentId)
  }

  func presentVisibleComments(allComments: [Comment]) {
    var visibleComments: [Comment] = []

    allComments.filter({ !$0.data.isDeleted }).forEach { comment in
      if comment.isOpen {
        visibleComments.append(comment)

        let reply = comment.data.reply.map {
          $0.filter { !$0.isDeleted }
        } ?? []

        visibleComments += reply.map {
          Comment(
            data: CommentResponse.Data(
              id: $0.id,
              userId: $0.userId,
              nickname: $0.nickname,
              image: $0.image,
              content: $0.content,
              regDate: $0.regDate,
              isDeleted: $0.isDeleted,
              replyCnt: 0,
              reply: []
            ), isReply: true
          )
        }
      } else {
        if !comment.isReply {
          visibleComments.append(comment)
        }
      }
    }
    self.view?.fetchVisibleComments(visibleComments: visibleComments)
  }

  func presentAllCommentsCount(allCommentsCount: Int) {
    self.view?.getAllCommentsCount(allCommentsCount: allCommentsCount)
  }
}
