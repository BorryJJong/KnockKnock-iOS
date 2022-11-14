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
}

final class CommentPresenter: CommentPresenterProtocol {
  var view: CommentViewProtocol?

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
    LoadingIndicator.hideLoading()
  }
}
