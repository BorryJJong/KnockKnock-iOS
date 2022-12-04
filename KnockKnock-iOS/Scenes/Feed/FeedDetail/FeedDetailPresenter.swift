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
  func presentLike(like: [LikeInfo])
}

final class FeedDetailPresenter: FeedDetailPresenterProtocol {
  weak var view: FeedDetailViewProtocol?

  func presentFeedDetail(feedDetail: FeedDetail) {
    self.view?.getFeedDetail(feedDetail: feedDetail)
    LoadingIndicator.hideLoading()
  }

  func presentLike(like: [LikeInfo]) {
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
                  isDeleted: false,
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
    self.view?.fetchVisibleComments(visibleComments: comments)
  }

  func presentAllCommentsCount(allCommentsCount: Int) {
    self.view?.getAllCommentsCount(allCommentsCount: allCommentsCount)
    print(allCommentsCount)
  }
}
