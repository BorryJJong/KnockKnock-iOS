//
//  FeedListRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/26.
//

import UIKit

final class FeedListRouter: FeedListRouterProtocol {
  weak var view: FeedListViewProtocol?
  
  static func createFeedList(
    feedId: Int,
    challengeId: Int
  ) -> UIViewController {
    
    let view = FeedListViewController()
    let interactor = FeedListInteractor()
    let presenter = FeedListPresenter()
    let worker = FeedListWorker(
      feedListRepository: FeedListRepository(),
      likeRepository: LikeRepository(),
      userDataManager: UserDataManager()
    )
    let router = FeedListRouter()
    
    view.interactor = interactor
    interactor.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view
    router.view = view
    
    view.feedId = feedId
    view.challengeId = challengeId
    
    return view
  }
  
  func navigateToFeedMain() {
    if let sourceView = self.view as? UIViewController {
      sourceView.navigationController?.popViewController(animated: true)
    }
  }
  
  func navigateToFeedDetail(feedId: Int) {
    let feedDetailViewController = FeedDetailRouter.createFeedDetail(feedId: feedId)
    if let sourceView = self.view as? UIViewController {
      feedDetailViewController.hidesBottomBarWhenPushed = true
      sourceView.navigationController?.pushViewController(feedDetailViewController, animated: true)
    }
  }
  
  func navigateToFeedEdit(feedId: Int) {
    let feedEditViewController = FeedEditRouter.createFeedEdit(feedId: feedId)
    if let sourceView = self.view as? UIViewController {
      feedEditViewController.hidesBottomBarWhenPushed = true
      sourceView.navigationController?.pushViewController(feedEditViewController, animated: true)
    }
  }
  
  func navigateToCommentView(feedId: Int) {
    let commentViewController = CommentRouter.createCommentView(feedId: feedId)
    if let sourceView = self.view as? UIViewController {
      commentViewController.modalPresentationStyle = .fullScreen
      sourceView.present(commentViewController, animated: true, completion: nil)
    }
  }
  
  func navigateToLoginView() {
    let loginViewController = LoginRouter.createLoginView()
    
    loginViewController.hidesBottomBarWhenPushed = true
    if let sourceView = self.view as? UIViewController {
      sourceView.navigationController?.pushViewController(loginViewController, animated: true)
    }
  }
  
  /// 신고하기 view present
  ///
  /// - Parameters:
  ///  - action: 신고하기 이벤트 closure
  ///  - reportDelegate: reportDelegate
  func presentReportView(
    action: (() -> Void)?,
    reportDelegate: ReportDelegate
  ) {
    guard let sourceView = self.view as? UIViewController else { return }
    
    let reportView = UINavigationController(
      rootViewController: ReportViewController().then {
        $0.reportAction = action
        $0.reportDelegate = reportDelegate
      }
    )
    
    sourceView.present(reportView, animated: true)
  }
  
  func presentBottomSheetView(
    bottomSheetSize: BottomSheetSize,
    options: [BottomSheetOption],
    feedData: FeedShare?
  ) {

    guard let bottomSheetViewController = BottomSheetRouter.createBottomSheet(
      options: options,
      bottomSheetSize: bottomSheetSize,
      feedData: feedData
    ) as? BottomSheetViewController else { return }

    bottomSheetViewController.modalPresentationStyle = .overFullScreen

    if let sourceView = self.view as? UIViewController {
      sourceView.present(
        bottomSheetViewController,
        animated: false,
        completion: nil
      )
    }
  }
}
