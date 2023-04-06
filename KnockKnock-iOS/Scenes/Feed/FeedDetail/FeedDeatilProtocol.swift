//
//  FeedDeatilProtocol.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/04/02.
//

import UIKit

protocol FeedDetailViewProtocol: AnyObject {
  var interactor: FeedDetailInteractorProtocol? { get set }

  func getFeedDetail(feedDetail: FeedDetail)
  func getAllCommentsCount(allCommentsCount: Int)
  func fetchVisibleComments(visibleComments: [Comment])
  func fetchLikeList(like: [Like.Info])
  func fetchLikeStatus(isToggle: Bool)
  func deleteComment()
  func setLoginStatus(isLoggedIn: Bool)

  func showAlertView(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

protocol FeedDetailInteractorProtocol {
  var worker: FeedDetailWorkerProtocol? { get set }
  var presenter: FeedDetailPresenterProtocol? { get set }
  var router: FeedDetailRouterProtocol? { get set }

  func getFeedDeatil(feedId: Int)
  func requestDelete(feedId: Int)
  func requestHide(feedId: Int)
  func requestReport(feedId: Int)
  func requestBlockUser(userId: Int)

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
    bottomSheetSize: BottomSheetSize,
    options: [BottomSheetOption],
    feedData: FeedDetail
  )
  func navigateToFeedEdit(feedId: Int)
}

protocol FeedDetailPresenterProtocol {
  var view: FeedDetailViewProtocol? { get set }

  func presentFeedDetail(feedDetail: FeedDetail)

  func presentAllCommentsCount(allCommentsCount: Int)
  func presentVisibleComments(comments: [Comment])
  func presentDeleteComment()

  func presentLikeList(like: [Like.Info])
  func presentLikeStatus(isToggle: Bool)

  func presentLoginStatus(isLoggedIn: Bool)

  func presentAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

protocol FeedDetailWorkerProtocol {
  func getFeedDetail(feedId: Int, completionHandler: @escaping (ApiResponse<FeedDetail>?) -> Void)

  func checkTokenIsValidated() async -> Bool

  func requestLike(
    isLike: Bool,
    feedId: Int,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )

  func toggleLike(feedDetail: FeedDetail?) -> FeedDetail?
  func fetchLikeList(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<[Like.Info]>?) -> Void
  )

  func getAllComments(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<[Comment]>?) -> Void
  )
  func fetchVisibleComments(comments: [Comment]?) -> [Comment]

  func requestAddComment(
    comment: AddCommentDTO,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
  func requestDeleteComment(
    feedId: Int,
    commentId: Int,
    comments: [Comment],
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )

  func requestDeleteFeed(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
  func requestHidePost(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
  func requestReportFeed(
    feedId: Int,
    reportType: ReportType,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
  func requestBlockUser(userId: Int) async -> ApiResponse<Bool>?
}

protocol FeedDetailRouterProtocol {
  var view: FeedDetailViewProtocol? { get set }

  static func createFeedDetail(feedId: Int) -> UIViewController

  func navigateToFeedEdit(feedId: Int)
  func navigateToLikeDetail(like: [Like.Info])
  func navigateToLoginView()
  func navigateToFeedList()
  func presentReportView(
    action: (() -> Void)?,
    reportDelegate: ReportDelegate
  )
  func presentBottomSheetView(
    bottomSheetSize: BottomSheetSize,
    options: [BottomSheetOption],
    feedData: FeedShare?
 )
}
