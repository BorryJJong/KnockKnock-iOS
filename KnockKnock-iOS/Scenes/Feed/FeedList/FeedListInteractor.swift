//
//  FeedListInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/26.
//

import Foundation

final class FeedListInteractor: FeedListInteractorProtocol {

  // MARK: - Properties

  var presenter: FeedListPresenterProtocol?
  var worker: FeedListWorkerProtocol?
  var router: FeedListRouterProtocol?
  
  private var feedListData: FeedList?

  var reportType: ReportType?
  
  // MARK: - Initialize
  
  init() {
    self.setNotification()
  }
  
  // MARK: - Business Logic
  
  /// 피드 리스트 조회
  ///
  /// - Parameters:
  ///   - currentPage: 현재 페이지
  ///   - pageSize: 페이지 사이즈
  ///   - feedId: 피드 아이디
  ///   - challengeId: 챌린지 아이디
  func fetchFeedList(
    currentPage: Int,
    pageSize: Int,
    feedId: Int,
    challengeId: Int
  ) {
    LoadingIndicator.showLoading()
    
    self.worker?.fetchFeedList(
      currentPage: currentPage,
      count: pageSize,
      feedId: feedId,
      challengeId: challengeId,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let feedList = response?.data else { return }

        if currentPage == 1 {
          self.feedListData = feedList

        } else {
          self.feedListData?.feeds += feedList.feeds
        }

        guard let feedListData = self.feedListData else { return }
        self.presenter?.presentFetchFeedList(feedList: feedListData)
      }
    )
  }
  
  /// 피드 삭제
  ///
  /// - Parameters:
  ///   - feedId: 피드 아이디
  func requestDelete(feedId: Int) {
    
    guard let feedList = self.feedListData else { return }
    guard !feedList.feeds.isEmpty else { return }
    
    // 삭제 요청한 피드가 현재 존재하는지 피드인지 체크
    guard feedList.feeds.contains(where: { feedId == $0.id }) else { return }
    
    self.worker?.requestDeleteFeed(
      feedId: feedId,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let isSuccess = response?.data else { return }

        if isSuccess {

          self.deletePost(
            feedList: feedList,
            feedId: feedId
          )
          
        } else {
          self.presentAlert(message: AlertMessage.feedDeleteFailed.rawValue)
        }
      }
    )
  }

  /// 피드 좋아요
  ///
  /// - Parameters:
  ///   - feedId: 피드 아이디
  func requestLike(feedId: Int) {

    Task {
      
      // 비로그인 유저인 경우 로그인 화면으로 이동
      guard await self.checkTokenIsValidated() else {
        await MainActor.run { self.router?.navigateToLoginView() }
        return
      }

      guard let feedList = self.feedListData?.feeds else { return }
      guard !feedList.isEmpty else { return }

      // 좋아요 누른 피드가 현재 존재하는지 피드인지 체크
      guard feedList.contains(where: { feedId == $0.id }) else { return }

      // 좋아요 이벤트 실행한 피드의 좋아요 여부
      guard let isLike = self.worker?.checkCurrentLikeState(
        feedList: feedList,
        feedId: feedId
      ) else { return }

      self.worker?.requestLike(
        isLike: isLike,
        feedId: feedId,
        completionHandler: { [weak self] response in

          guard let self = self else { return }

          self.showErrorAlert(response: response)

          guard let isSuccess = response?.data else { return }

          guard isSuccess else {

            self.presentAlert(message: AlertMessage.unknownedError.rawValue)
            return
          }

          self.toggleLike(feedId: feedId)
        }
      )
    }
  }

  /// 피드 숨기기
  func requestHide(feedId: Int) {

    guard let feedList = self.feedListData else { return }
    guard !feedList.feeds.isEmpty else { return }

    // 삭제 요청한 피드가 현재 존재하는지 피드인지 체크
    guard feedList.feeds.contains(where: { feedId == $0.id }) else { return }

    self.worker?.requestHidePost(
      feedId: feedId,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let isSuccess = response?.data else { return }

        if isSuccess {
          // 피드 리스트 내 해당 게시글 모두 삭제
          guard let feedListData = self.worker?.removePostInFeedList(
            feeds: feedList,
            id: feedId
          ) else { return }

          self.presenter?.presentFetchFeedList(feedList: feedListData)

        } else {
          self.presentAlert(message: AlertMessage.feedHideFailed.rawValue)
        }
      }
    )
  }

  /// 피드 신고하기
  func requestReport(feedId: Int) {

    guard let feedList = self.feedListData else { return }
    guard !feedList.feeds.isEmpty else { return }

    guard let reportType = self.reportType else { return }

    self.worker?.requestReportFeed(
      feedId: feedId,
      reportType: reportType,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let isSuccess = response?.data else { return }

        if isSuccess {
          // 피드 리스트 내 해당 게시글 모두 숨김(삭제)처리
          guard let feedListData = self.worker?.removePostInFeedList(
            feeds: feedList,
            id: feedId
          ) else { return }

          self.presentAlert(message: AlertMessage.feedReportDone.rawValue)
          self.presenter?.presentFetchFeedList(feedList: feedListData)

        } else {
          self.presentAlert(message: AlertMessage.feedReportFailed.rawValue)
        }
      }
    )
  }

  func requestBlockUser(userId: Int) {

    Task {

      let response = await self.worker?.requestBlockUser(userId: userId)

      await MainActor.run {
        self.showErrorAlert(response: response)
      }

      guard let isSuccess = response?.data else { return }

      if isSuccess {
        self.presentAlert(message: AlertMessage.userBlockDone.rawValue)

      } else {
        self.presentAlert(message: AlertMessage.userBlockFailed.rawValue)

      }
    }
  }
  
  // Routing
  
  func navigateToFeedDetail(feedId: Int) {
    self.router?.navigateToFeedDetail(feedId: feedId)
  }
  
  func navigateToCommentView(feedId: Int) {
    self.router?.navigateToCommentView(feedId: feedId)
  }

  func navigateToFeedEdit(feedId: Int) {
    self.router?.navigateToFeedEdit(feedId: feedId)
  }

  func navigateToFeedMain() {
    self.router?.navigateToFeedMain()
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
    bottomSheetSize: BottomSheetSize,
    options: [BottomSheetOption],
    feedData: FeedList.Post
  ) {
    Task {

      if await self.checkTokenIsValidated() {

        await MainActor.run {
          self.router?.presentBottomSheetView(
            bottomSheetSize: bottomSheetSize,
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

// MARK: - Report Delegate

extension FeedListInteractor: ReportDelegate {
  func setReportType(reportType: ReportType) {
    self.reportType = reportType
  }
}

// MARK: - Inner Actions

extension FeedListInteractor {

  private func checkTokenIsValidated() async -> Bool {
    guard let isValidate = await self.worker?.checkTokenIsValidated() else { return false }

    return isValidate
  }

  /// 피드 상세에서 발생한 좋아요 이벤트 반영
  @objc
  private func likeNotificationEvent(_ notification: Notification) {
    guard let feedId = notification.object as? Int else { return }
    self.toggleLike(feedId: feedId)
  }

  /// 피드 상세에서 발생한 삭제 이벤트 반영
  @objc
  private func deleteNotificationEvent(_ notification: Notification) {
    guard let feedId = notification.object as? Int else { return }

    guard let feedList = self.feedListData else { return }
    guard !feedList.feeds.isEmpty else { return }

    // 삭제 요청한 피드가 현재 존재하는지 피드인지 체크
    guard feedList.feeds.contains(where: { feedId == $0.id }) else { return }

    self.deletePost(feedList: feedList, feedId: feedId)
  }

  /// 댓글 등록 시 댓글 개수 업데이트
  @objc
  private func addCommentNotificationEvent(_ notification: Notification) {
    guard let feedId = notification.object as? Int else { return }

    guard let feedListData = self.feedListData else { return }
    guard !feedListData.feeds.isEmpty else { return }

    // 현재 존재하는지 피드인지 체크
    guard feedListData.feeds.contains(where: { feedId == $0.id }) else { return }

    guard let convertFeedList = self.worker?.convertComment(
      feeds: feedListData,
      id: feedId,
      replyCount: nil,
      isAdded: true
    ) else { return }

    self.feedListData = convertFeedList

    let updatedSections: [IndexPath] = self.worker?.changedSections(
      feeds: feedListData.feeds,
      id: feedId
    )
      .map { IndexPath(item: 0, section: $0) } ?? []

    self.presenter?.presentUpdateFeedList(
      feedList: convertFeedList,
      sections: updatedSections
    )
  }

  /// 댓글 삭제시 댓글 개수 업데이트
  @objc
  private func deleteCommentNotificationEvent(_ notification: Notification) {
    guard let data = notification.object as? [String: Any],
          let feedId = data["feedId"] as? Int,
          let replyCount = data["replyCount"] as? Int else { return }

    guard let feedListData = self.feedListData else { return }
    guard !feedListData.feeds.isEmpty else { return }

    // 현재 존재하는지 피드인지 체크
    guard feedListData.feeds.contains(where: { feedId == $0.id }) else { return }

    guard let convertFeedList = self.worker?.convertComment(
      feeds: feedListData,
      id: feedId,
      replyCount: replyCount,
      isAdded: false
    ) else { return }

    self.feedListData = convertFeedList

    let updatedSections: [IndexPath] = self.worker?.changedSections(
      feeds: feedListData.feeds,
      id: feedId
    )
      .map { IndexPath(item: 0, section: $0) } ?? []

    self.presenter?.presentUpdateFeedList(
      feedList: convertFeedList,
      sections: updatedSections
    )
  }

  /// 피드 수정 이벤트 반영
  @objc
  private func editNotificationEvent(_ notification: Notification) {
    guard let feedData = notification.object as? [String: Any] else { return }

    guard let feedId = feedData["feedId"] as? Int else { return }
    guard let contents = feedData["contents"] as? String else { return }

    guard let feedList = self.feedListData else { return }
    guard !feedList.feeds.isEmpty else { return }

    // 수정 요청한 피드가 현재 존재하는지 피드인지 체크
    guard feedList.feeds.contains(where: { feedId == $0.id }) else { return }

    self.updatePost(
      feedList: feedList,
      feedId: feedId,
      contents: contents
    )
  }

  /// 좋아요 상태 toggle
  ///
  /// - Parameters:
  ///  - feedId: 피드 아이디
  private func toggleLike(feedId: Int) {

    guard let feedListData = self.feedListData else { return }
    guard !feedListData.feeds.isEmpty else { return }

    guard let convertFeedList = self.worker?.convertLikeFeed(
      feeds: feedListData,
      id: feedId
    ) else {
      return
    }

    self.feedListData = convertFeedList

    let updatedSections: [IndexPath] = self.worker?.changedSections(
      feeds: feedListData.feeds,
      id: feedId
    )
      .map { IndexPath(item: 0, section: $0) } ?? []

    self.presenter?.presentUpdateFeedList(
      feedList: convertFeedList,
      sections: updatedSections
    )
  }

  /// 피드 삭제 반영
  ///
  /// - Parameters:
  ///  - feedList: 현재 조회 된 피드 데이터
  ///  - feedId: 삭제 될 피드 아이디
  private func deletePost(
    feedList: FeedList,
    feedId: Int
  ) {
    // 피드 리스트 내 해당 게시글 모두 삭제
    guard let feedListData = self.worker?.removePostInFeedList(
      feeds: feedList,
      id: feedId
    ) else { return }

    self.presenter?.presentFetchFeedList(feedList: feedListData)
  }

  /// 피드 수정 반영
  ///
  /// - Parameters:
  ///  - feedList: 현재 로드 된 피드 리스트 데이터
  ///  - feedId: 피드 아이디
  ///  - contents: 수정 된 내용
  private func updatePost(
    feedList: FeedList,
    feedId: Int,
    contents: String
  ) {
    // 피드 리스트 내 해당 게시글 모두 삭제
    guard let feedListData = self.worker?.updatePostInFeedList(
      feeds: feedList,
      feedId: feedId,
      contents: contents
    ) else { return }

    self.presenter?.presentFetchFeedList(feedList: feedListData)
  }

  // Notification Center

  private func setNotification() {
    NotificationCenter.default.addObserver(
      forName: .feedListRefreshAfterSigned,
      object: nil,
      queue: nil
    ) { _ in
      self.presenter?.reloadFeedList()
    }

    NotificationCenter.default.addObserver(
      forName: .feedListRefreshAfterUnsigned,
      object: nil,
      queue: nil
    ) { _ in
      self.presenter?.reloadFeedList()
    }

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.likeNotificationEvent(_:)),
      name: .postLikeToggled,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.deleteNotificationEvent(_:)),
      name: .feedListRefreshAfterDelete,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.addCommentNotificationEvent(_:)),
      name: .feedListCommentRefreshAfterAdd,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.deleteCommentNotificationEvent(_:)),
      name: .feedListCommentRefreshAfterDelete,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.editNotificationEvent(_:)),
      name: .feedListRefreshAfterEdited,
      object: nil
    )
  }

  // MARK: - Error

  private func showErrorAlert<T>(response: ApiResponse<T>?) {
    guard let response = response else {
      DispatchQueue.main.async {
        LoadingIndicator.hideLoading()

        self.presentAlert(message: AlertMessage.unknownedError.rawValue)
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
