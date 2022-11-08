//
//  CommentPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import Foundation

protocol CommentPresenterProtocol {
  var view: CommentViewProtocol? { get set }

  func presentAllComments(allComments: [Comment])
  func setVisibleComments(visibleComments: [Comment])
}

final class CommentPresenter: CommentPresenterProtocol {
  var view: CommentViewProtocol?

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
