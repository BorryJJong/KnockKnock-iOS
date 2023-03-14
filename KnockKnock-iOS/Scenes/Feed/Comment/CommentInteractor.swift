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
  func checkLoginStatus()

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

  /// 로그인 상태 체크
  func checkLoginStatus() {
    Task {
      self.presenter?.presentLoginStatus(
        isLoggedIn: await self.checkTokenIsValidated()
      )
    }
  }

  /// 댓글 목록 조회 api로부터 받은 전체 댓글 fetch
  func fetchAllComments(feedId: Int) {

    self.worker?.getAllComments(
      feedId: feedId,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let comments = response?.data else { return }

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
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response )

        guard let isSuccess = response?.data else { return }

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
      comments: self.comments,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response )

        guard let isSuccess = response?.data else { return }

        if isSuccess {

          guard let convertComments = self.worker?.convertDeletedComment(
            comments: self.comments,
            commentId: commentId
          ) else { return }
          
          self.comments = convertComments

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

extension CommentInteractor {
  private func checkTokenIsValidated() async -> Bool {
    guard let isValidate = await self.worker?.checkTokenIsValidated() else { return false }

    return isValidate
  }

  // MARK: - Error

  private func showErrorAlert<T>(response: ApiResponse<T>?) {
    guard let response = response else {
      DispatchQueue.main.async {
        LoadingIndicator.hideLoading()

        self.showAlertView(
          message: "네트워크 연결을 확인해 주세요.",
          confirmAction: nil
        )
      }
      return
    }

    guard response.data != nil else {

      DispatchQueue.main.async {
        LoadingIndicator.hideLoading()

        self.showAlertView(
          message: response.message,
          confirmAction: nil
        )
      }
      return
    }
  }
}
