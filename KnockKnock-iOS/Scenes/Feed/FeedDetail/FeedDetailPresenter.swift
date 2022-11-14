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
  func presentVisibleComments(allComments: [Comment])
  func presentLike(like: [Like])
}

final class FeedDetailPresenter: FeedDetailPresenterProtocol {
  weak var view: FeedDetailViewProtocol?

  func presentFeedDetail(feedDetail: FeedDetail) {
    self.view?.getFeedDetail(feedDetail: feedDetail)
    LoadingIndicator.hideLoading()
  }

  func presentLike(like: [Like]) {
    self.view?.getLike(like: like)
  }

  func presentVisibleComments(allComments: [Comment]) {
    var comments: [Comment] = []

    for comment in allComments {
      if comment.commentData.reply?.count != 0 && comment.isOpen {
        comments.append(comment)
        if let replyArray = comment.commentData.reply {
          for reply in replyArray {
            comments.append(
              Comment(
                commentData: CommentData(
                  id: reply.id,
                  userId: reply.userId,
                  nickname: reply.nickname,
                  image: reply.image,
                  content: reply.content,
                  regDate: reply.regDate,
                  isDeleted: 0,
                  replyCnt: 0,
                  reply: []
                ),
                isReply: true
              )
            )
          }
        }
      } else {
        if !comment.isReply {
          comments.append(comment)
        }
      }
    }
    self.view?.fetchVisibleComments(comments: comments)
  }
}
