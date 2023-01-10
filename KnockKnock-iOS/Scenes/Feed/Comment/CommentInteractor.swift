//
//  CommentInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import Foundation

protocol CommentInteractorProtocol {
  var worker: CommentWorkerProtocol? { get set }
  var presenter: CommentPresenterProtocol? { get set }

  func fetchAllComments(feedId: Int)
  func toggleVisibleStatus(commentId: Int)
  func fetchVisibleComments()
  func requestAddComment(comment: AddCommentRequest)
  func requestDeleteComment(commentId: Int)
}

final class CommentInteractor: CommentInteractorProtocol {
  var worker: CommentWorkerProtocol?
  var presenter: CommentPresenterProtocol?

  /// 서버에서 받아온 전체 댓글 array
  var comments: [Comment] = []

  /// view에서 보여지는 댓글 array(open 상태 댓글만)
  var visibleComments: [Comment] = []

  /// 댓글 목록 조회 api로부터 받은 전체 댓글 fetch
  func fetchAllComments(feedId: Int) {
    self.worker?.getAllComments(
      feedId: feedId,
      completionHandler: { [weak self] comments in
        self?.comments = comments
        self?.fetchVisibleComments()
      }
    )
  }

  /// 답글 펼침/숨김 상태 toggle
  func toggleVisibleStatus(commentId: Int) {
    guard let index = self.comments.firstIndex(where: {
      $0.data.id == commentId
    }) else { return }
    
    self.comments[index].isOpen.toggle()
    self.fetchVisibleComments()
  }

  /// 전체 댓글에서 삭제된 댓글, 숨김(접힘) 상태 댓글을 제외하고 보여질 댓글만 필터링
  func fetchVisibleComments() {
    self.visibleComments = []

    self.comments.filter({
      !$0.data.isDeleted
    }).forEach { comment in

      if comment.isOpen {
        self.visibleComments.append(comment)

        let reply = comment.data.reply.map {
          $0.filter { !$0.isDeleted }
        } ?? []

        self.visibleComments += reply.map {
          Comment(
            data: CommentResponse(
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
    self.presenter?.presentVisibleComments(comments: self.visibleComments)
  }

  /// 댓글 등록
  func requestAddComment(comment: AddCommentRequest) {
    self.worker?.requestAddComment(
      comment: comment,
      completionHandler: { success in
        if success {
          self.fetchAllComments(feedId: comment.postId)
        }
      }
    )
  }

  /// 댓글 삭제
  func requestDeleteComment(commentId: Int) {
    self.worker?.requestDeleteComment(
      commentId: commentId,
      completionHandler: {

        if let index = self.comments.firstIndex(where: { $0.data.id == commentId }) {
          self.comments[index].data.isDeleted = true
        }

        for commentIndex in 0..<self.comments.count {
          if let replyIndex = self.comments[commentIndex].data.reply?.firstIndex(where: {
            $0.id == commentId
          }) {
            self.comments[commentIndex].data.reply?[replyIndex].isDeleted = true
          }
        }

        self.fetchVisibleComments()
      }
    )
  }
}
