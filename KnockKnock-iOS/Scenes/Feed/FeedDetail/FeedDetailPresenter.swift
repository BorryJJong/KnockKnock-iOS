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
  func presentAllComments(allComments: [Comment])
  func setVisibleComments(visibleComments: [Comment])
}

final class FeedDetailPresenter: FeedDetailPresenterProtocol {
  var view: FeedDetailViewProtocol?

  func presentFeedDetail(feedDetail: FeedDetail) {
    self.view?.getFeedDetail(feedDetail: feedDetail)
  }

  func presentAllComments(allComments: [Comment]) {
    self.view?.getAllComments(allComments: allComments)
  }

  func setVisibleComments(visibleComments: [Comment]) {
    var comments: [Comment] = []

    for comment in visibleComments {
      if comment.replies.count != 0 && comment.isOpen {
        comments.append(comment)

        for reply in comment.replies {
          comments.append(
            Comment(
              userID: reply.userID,
              image: reply.image,
              contents: reply.contents,
              replies: [],
              date: reply.date,
              isReply: true
            )
          )
        }
      } else {
        if !comment.isReply {
          comments.append(comment)
        }
      }
    }
    self.view?.setVisibleComments(comments: comments)
  }
}
