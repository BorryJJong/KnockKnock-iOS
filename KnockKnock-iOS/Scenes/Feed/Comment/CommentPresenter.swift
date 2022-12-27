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
  func presentDeleteComment()
}

final class CommentPresenter: CommentPresenterProtocol {
  var view: CommentViewProtocol?
  
  func presentDeleteComment() {
    self.view?.deleteComment()
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
    self.view?.fetchVisibleComments(comments: visibleComments)
    LoadingIndicator.hideLoading()
  }
}
