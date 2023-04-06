//
//  FeedListProtocol.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/03/31.
//

import UIKit

protocol FeedListViewProtocol: AnyObject {
  var interactor: FeedListInteractorProtocol? { get set }

  func fetchFeedList(feedList: FeedList)
  func updateFeedList(
    feedList: FeedList,
    sections: [IndexPath]
  )
  func reloadFeedList()

  func showAlertView(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

protocol FeedListInteractorProtocol {
  var presenter: FeedListPresenterProtocol? { get set }
  var worker: FeedListWorkerProtocol? { get set }
  var router: FeedListRouterProtocol? { get set }

  func fetchFeedList(
    currentPage: Int,
    pageSize: Int,
    feedId: Int,
    challengeId: Int
  )
  func requestDelete(feedId: Int)
  func requestHide(feedId: Int)
  func requestLike(feedId: Int)
  func requestReport(feedId: Int)
  func requestBlockUser(userId: Int)

  func presentBottomSheetView(
    bottomSheetSize: BottomSheetSize,
    options: [BottomSheetOption],
    feedData: FeedList.Post
  )
  func presentReportView(feedId: Int)
  func navigateToFeedEdit(feedId: Int)
  func navigateToFeedMain()
  func navigateToFeedDetail(feedId: Int)
  func navigateToCommentView(feedId: Int)
}

protocol FeedListPresenterProtocol {
  var view: FeedListViewController? { get set }

  func presentFetchFeedList(feedList: FeedList)
  func presentUpdateFeedList(feedList: FeedList, sections: [IndexPath])
  func reloadFeedList()

  func presentAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

protocol FeedListWorkerProtocol {
  func fetchFeedList(
    currentPage: Int,
    count: Int,
    feedId: Int,
    challengeId: Int,
    completionHandler: @escaping (ApiResponse<FeedList>?) -> Void
  )
  func requestDeleteFeed(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
  func requestLike(
    isLike: Bool,
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

  func removePostInFeedList(
    feeds: FeedList,
    id: Int
  ) -> FeedList

  func updatePostInFeedList(
    feeds: FeedList,
    feedId: Int,
    contents: String
  ) -> FeedList

  func checkTokenIsValidated() async -> Bool

  func checkCurrentLikeState(
    feedList: [FeedList.Post],
    feedId: Int
  ) -> Bool

  func changedSections(
    feeds: [FeedList.Post],
    id: Int
  ) -> [Int]

  func convertLikeFeed(
    feeds: FeedList,
    id: Int
  ) -> FeedList

  func convertComment(
    feeds: FeedList,
    id: Int,
    replyCount: Int?,
    isAdded: Bool
  ) -> FeedList
}

protocol FeedListRouterProtocol {
  var view: FeedListViewProtocol? { get set }
  static func createFeedList(feedId: Int, challengeId: Int) -> UIViewController

  func presentBottomSheetView(
    bottomSheetSize: BottomSheetSize,
    options: [BottomSheetOption],
    feedData: FeedShare?
  )
  func presentReportView(
    action: (() -> Void)?,
    reportDelegate: ReportDelegate
  )
  func navigateToFeedEdit(feedId: Int)
  func navigateToFeedMain()
  func navigateToFeedDetail(feedId: Int)
  func navigateToCommentView(feedId: Int)
  func navigateToLoginView()
}
