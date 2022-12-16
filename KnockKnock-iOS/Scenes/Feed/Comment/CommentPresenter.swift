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
  func presentDeleteComment(commentId: Int)
}

final class CommentPresenter: CommentPresenterProtocol {
  var view: CommentViewProtocol?

  func presentDeleteComment(commentId: Int) {
    self.view
  }

  func presentVisibleComments(allComments: [Comment]) {
    var comments: [Comment] = []

    for comment in allComments {
      if comment.data.reply?.count != 0 && comment.isOpen {
        comments.append(comment)

        if let replyArray = comment.data.reply {
          for reply in replyArray {
            comments.append(
              Comment(
                data: CommentResponse.Data(
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
    self.view?.fetchVisibleComments(comments: comments)
    LoadingIndicator.hideLoading()
  }
}
