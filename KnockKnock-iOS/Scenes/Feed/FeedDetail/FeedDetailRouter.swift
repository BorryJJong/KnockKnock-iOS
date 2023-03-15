//
//  FeedDetailRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import UIKit

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
    options: [BottomSheetOption],
    feedData: FeedShare?
 )
}

final class FeedDetailRouter: FeedDetailRouterProtocol {
  
  weak var view: FeedDetailViewProtocol?
  
  static func createFeedDetail(feedId: Int) -> UIViewController {
    let view = FeedDetailViewController()
    let interactor = FeedDetailInteractor()
    let presenter = FeedDetailPresenter()
    let worker = FeedDetailWorker(
      feedDetailRepository: FeedDetailRepository(),
      commentRepository: CommentRepository(),
      likeRepository: LikeRepository(),
      userDataManager: UserDataManager()
    )
    let router = FeedDetailRouter()
    
    view.feedId = feedId
    view.interactor = interactor
    interactor.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view
    router.view = view
    
    return view
  }

  func navigateToLikeDetail(like: [Like.Info]) {
    let likeDetailViewController = LikeDetailViewContoller()
    
    if let sourceView = self.view as? UIViewController {
      likeDetailViewController.like = like
      sourceView.navigationController?.pushViewController(likeDetailViewController, animated: true)
    }
  }
  
  func navigateToFeedList() {
    if let sourceView = self.view as? UIViewController {
      sourceView.navigationController?.popViewController(animated: true)
    }
  }

  func navigateToFeedEdit(feedId: Int) {
    let feedEditViewController = FeedEditRouter.createFeedEdit(feedId: feedId)
    if let sourceView = self.view as? UIViewController {
      feedEditViewController.hidesBottomBarWhenPushed = true
      sourceView.navigationController?.pushViewController(feedEditViewController, animated: true)
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
    options: [BottomSheetOption],
    feedData: FeedShare?
  ) {
    
    guard let bottomSheetViewController = BottomSheetRouter.createBottomSheet(
      options: options,
      bottomSheetSize: .medium,
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
