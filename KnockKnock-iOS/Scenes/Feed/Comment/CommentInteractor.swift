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
  func requestAddComment(comment: AddCommentDTO)
  func toggleVisibleStatus(commentId: Int)
  func requestDeleteComment(
    feedId: Int,
    commentId: Int
  )

  func dismissCommentView()
  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  )
}

final class CommentInteractor: CommentInteractorProtocol {
  var worker: CommentWorkerProtocol?
  var presenter: CommentPresenterProtocol?
  var router: CommentRouterProtocol?

  /// 서버에서 받아온 전체 댓글 array
  private var comments: [Comment] = []

  /// view에서 보여지는 댓글 array(open 상태 댓글만)
  private var visibleComments: [Comment] = []

  /// 댓글 목록 조회 api로부터 받은 전체 댓글 fetch
  func fetchAllComments(feedId: Int) {
    self.worker?.getAllComments(
      feedId: feedId,
      completionHandler: { [weak self] comments in

        guard let self = self else { return }

        self.comments = comments
        self.visibleComments = self.worker?.fetchVisibleComments(comments: self.comments) ?? []
        self.presenter?.presentVisibleComments(comments: self.visibleComments)
      }
    )
  }

  /// 답글 펼침/숨김 상태 toggle
  ///
  /// - Parameters:
  ///  - commentId: 댓글 아이디
  func toggleVisibleStatus(commentId: Int) {
    guard let index = self.comments.firstIndex(where: {
      $0.data.id == commentId
    }) else { return }
    
    self.comments[index].isOpen.toggle()
    self.visibleComments = self.worker?.fetchVisibleComments(comments: self.comments) ?? []
    self.presenter?.presentVisibleComments(comments: self.visibleComments)
  }

  /// 댓글 등록
  ///
  /// - Parameters:
  ///  - comment: 등록 할 댓글 데이터
  func requestAddComment(comment: AddCommentDTO) {
    self.worker?.requestAddComment(
      comment: comment,
      completionHandler: { [weak self] isSuccess in

        guard let self = self else { return }

        if isSuccess {
          self.fetchAllComments(feedId: comment.postId)

        } else {
          self.showAlertView(
            message: "댓글 등록에 실패하였습니다.",
            confirmAction: nil
          )
        }
      }
    )
  }

  /// 댓글 삭제
  ///
  /// - Parameters:
  ///  - feedId: 댓글이 달려있는 피드 아이디
  ///  - commentId: 댓글 아이디
  func requestDeleteComment(
    feedId: Int,
    commentId: Int
  ) {
    self.worker?.requestDeleteComment(
      feedId: feedId,
      commentId: commentId,
      completionHandler: { [weak self] isSuccess in

        guard let self = self else { return }

        if isSuccess {

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

          self.visibleComments = self.worker?.fetchVisibleComments(comments: self.comments) ?? []
          self.presenter?.presentVisibleComments(comments: self.visibleComments)

        } else {

          self.showAlertView(
            message: "댓글 삭제에 실패하였습니다.",
            confirmAction: nil
          )
        }
      }
    )
  }

  // MARK: - Routing

  func dismissCommentView() {
    self.router?.dismissCommentView()
  }

  /// AlertView
  ///
  /// - Parameters:
  ///  - message: 알림창 메세지
  ///  - confirmAction: 확인 눌렀을 때 수행 될 액션
  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  ) {
    self.router?.showAlertView(
      message: message,
      confirmAction: confirmAction
    )
  }
}
