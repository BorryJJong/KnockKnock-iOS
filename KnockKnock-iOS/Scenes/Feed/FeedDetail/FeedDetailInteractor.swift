//
//  FeedDetailInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import Foundation

protocol FeedDetailInteractorProtocol {
  var worker: FeedDetailWorkerProtocol? { get set }
  var presenter: FeedDetailPresenterProtocol? { get set }
  var router: FeedDetailRouterProtocol? { get set }
  
  func getFeedDeatil(feedId: Int)
  func requestDelete(feedId: Int)
  func requestHide(feedId: Int)
  func requestReport(feedId: Int)
  
  func fetchAllComments(feedId: Int)
  
  func fetchVisibleComments(comments: [Comment])
  func requestAddComment(comment: AddCommentDTO)
  func toggleVisibleStatus(commentId: Int)
  func requestDeleteComment(feedId: Int, commentId: Int)
  
  func requestLike(feedId: Int)
  func fetchLikeList(feedId: Int)
  
  func presentReportView(feedId: Int)
  func navigateToLikeDetail()
  func navigateToFeedList()
  func checkLoginStatus()
  func presentBottomSheetView(
    options: [BottomSheetOption],
    feedData: FeedDetail
  )
  func navigateToFeedEdit(feedId: Int)
}

extension FeedDetailInteractor: ReportDelegate {
  func setReportType(reportType: ReportType) {
    self.reportType = reportType
  }
}

final class FeedDetailInteractor: FeedDetailInteractorProtocol {
  var worker: FeedDetailWorkerProtocol?
  var presenter: FeedDetailPresenterProtocol?
  var router: FeedDetailRouterProtocol?
  
  private var likeList: [Like.Info] = []
  
  /// 서버에서 받아온 전체 댓글 array
  private var comments: [Comment] = []
  
  /// view에서 보여지는 댓글 array(open 상태 댓글만)
  private var visibleComments: [Comment] = []

  /// 신고 타입
  var reportType: ReportType?
  
  private var feedDetail: FeedDetail?
  
  // MARK: - Initialize
  
  init() {
    self.setNotification()
  }
  
  // MARK: - Business logic

  /// 로그인 상태 체크
  func checkLoginStatus() {
    Task {
      self.presenter?.presentLoginStatus(
        isLoggedIn: await self.checkTokenIsValidated()
      )
    }
  }

  func getFeedDeatil(feedId: Int) {
    self.worker?.getFeedDetail(
      feedId: feedId,
      completionHandler: { [weak self] response in
        
        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let feedDetail = response?.data else { return }

        self.feedDetail = feedDetail
        self.presenter?.presentFeedDetail(feedDetail: feedDetail)
      }
    )
  }
  
  func requestLike(feedId: Int) {

    Task {
      // 비로그인 유저인 경우 로그인 화면으로 이동
      guard await self.checkTokenIsValidated() else {
        await MainActor.run { self.router?.navigateToLoginView() }
        return
      }

      // 좋아요 이벤트 실행한 피드의 좋아요 여부
      guard let isLike = self.feedDetail?.feed.isLike else { return }

      self.worker?.requestLike(
        isLike: isLike,
        feedId: feedId,
        completionHandler: { [weak self] response in

          guard let self = self else { return }

          self.showErrorAlert(response: response)

          guard let isSuccess = response?.data,
                    isSuccess else { return }

          self.feedDetail = self.worker?.toggleLike(feedDetail: self.feedDetail)

          self.presenter?.presentLikeStatus(isToggle: isSuccess)
          self.fetchLikeList(feedId: feedId)
        }
      )
    }
  }
  
  func fetchLikeList(feedId: Int) {
    self.worker?.fetchLikeList(
      feedId: feedId,
      completionHandler: { [weak self] response in
        
        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let likeList = response?.data else { return }
        
        self.likeList = likeList
        self.presenter?.presentLikeList(like: likeList)
      }
    )
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
        self.fetchAllCommentsCount()
        self.visibleComments = self.worker?.fetchVisibleComments(comments: self.comments) ?? []
        self.presenter?.presentVisibleComments(comments: self.visibleComments)
      }
    )
  }
  
  /// 답글 펼침/숨김 상태 toggle
  func toggleVisibleStatus(commentId: Int) {
    guard let index = self.comments.firstIndex(where: {
      $0.data.id == commentId
    }) else { return }
    
    self.comments[index].isOpen.toggle()
    
    self.visibleComments = self.worker?.fetchVisibleComments(comments: self.comments) ?? []
    self.presenter?.presentVisibleComments(comments: self.visibleComments)
  }
  
  /// 답글을 포함한 모든 댓글의 수 (헤더에 표기)
  func fetchAllCommentsCount() {
    var count = self.comments.filter { !$0.data.isDeleted }.count
    
    self.comments.forEach { comment in
      count += comment.data.reply
        .map {
          $0.filter { !$0.isDeleted }
        }?
        .count ?? 0
    }
    self.presenter?.presentAllCommentsCount(allCommentsCount: count)
  }
  
  /// 비숨김 처리 댓글 fetch
  /// 매번 모든 댓글을 받아오지 않도록 별도 정의
  func fetchVisibleComments(comments: [Comment]) {
    self.presenter?.presentVisibleComments(comments: comments)
  }
  
  /// 댓글 등록
  func requestAddComment(
    comment: AddCommentDTO
  ) {

    self.worker?.requestAddComment(
      comment: comment,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let isSuccess = response?.data else { return }

        if isSuccess {
          self.fetchAllComments(feedId: comment.postId)
          self.fetchAllCommentsCount()

        } else {
          self.presentAlert(message: "댓글 등록에 실패하였습니다.")
        }
      }
    )

  }

  /// 댓글 삭제
  func requestDeleteComment(feedId: Int, commentId: Int) {
    self.worker?.requestDeleteComment(
      feedId: feedId,
      commentId: commentId,
      comments: self.comments,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let isSuccess = response?.data else { return }

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
          self.fetchAllCommentsCount()

        } else {

          self.presentAlert(message: "댓글 삭제에 실패하였습니다.")
        }
      }
    )
  }

  /// 피드 삭제
  func requestDelete(feedId: Int) {

    self.worker?.requestDeleteFeed(
      feedId: feedId,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let isSuccess = response?.data else { return }

        if isSuccess {
          self.presentAlert(
            message: "게시글이 삭제되었습니다.",
            confirmAction: {
              self.navigateToFeedList()
            }
          )
        } else {
          self.presentAlert(message: "게시글 삭제 중 오류가 발생하였습니다.")
        }
      }
    )
  }

  /// 피드 숨기기
  func requestHide(feedId: Int) {

    self.worker?.requestHidePost(
      feedId: feedId,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let isSuccess = response?.data else { return }

        if isSuccess {
          self.presentAlert(
            message: "게시글이 숨김 처리 되었습니다.",
            confirmAction: {
              self.navigateToFeedList()
            }
          )
        } else {
          self.presentAlert(message: "게시글 숨김 처리에 실패하였습니다.")
        }
      }
    )
  }

  /// 피드 신고하기
  func requestReport(
    feedId: Int
  ) {

    guard let reportType = self.reportType else { return }

    self.worker?.requestReportFeed(
      feedId: feedId,
      reportType: reportType,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let isSuccess = response?.data else { return }

        if isSuccess {
          self.presentAlert(
            message: "게시글이 신고 되었습니다.",
            confirmAction: {
              self.navigateToFeedList()
            }
          )
        } else {
          self.presentAlert(message: "게시글 신고에 실패하였습니다.")
        }
      }
    )
  }

  // Routing

  func navigateToLikeDetail() {
    self.router?.navigateToLikeDetail(like: self.likeList)
  }

  func navigateToFeedList() {
    self.router?.navigateToFeedList()
  }

  func navigateToFeedEdit(feedId: Int) {
    self.router?.navigateToFeedEdit(feedId: feedId)
  }
  
  func presentReportView(feedId: Int) {
    self.router?.presentReportView(
      action: {
        self.requestReport(feedId: feedId)
      },
      reportDelegate: self
    )
  }

  func presentBottomSheetView(
    options: [BottomSheetOption],
    feedData: FeedDetail
  ) {

    Task {

      if await self.checkTokenIsValidated() {

        await MainActor.run {
          self.router?.presentBottomSheetView(
            options: options,
            feedData: feedData.toShare()
          )
        }
      } else {

        await MainActor.run {
          self.router?.navigateToLoginView()
        }
      }
    }
  }
}

extension FeedDetailInteractor {
  
  /// 수정 된 피드 refetch
  @objc
  private func editNotificationEvent(_ notification: Notification) {
    guard let feedId = notification.object as? Int else { return }
    self.getFeedDeatil(feedId: feedId)
  }
  
  private func setNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.editNotificationEvent(_:)),
      name: .feedDetailRefreshAfterEdited,
      object: nil
    )
  }
  
  private func checkTokenIsValidated() async -> Bool {
    guard let isValidate = await self.worker?.checkTokenIsValidated() else { return false }
    
    return isValidate
  }

  // MARK: - Error

  private func showErrorAlert<T>(response: ApiResponse<T>?) {
    guard let response = response else {
      DispatchQueue.main.async {
        LoadingIndicator.hideLoading()

        self.presentAlert(message: "네트워크 연결을 확인해 주세요.")
      }
      return
    }

    guard response.data != nil else {
      DispatchQueue.main.async {
        LoadingIndicator.hideLoading()

        self.presentAlert(message: response.message)
      }
      return
    }
  }

  private func presentAlert(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: (() -> Void)? = nil
  ) {
    self.presenter?.presentAlert(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}
