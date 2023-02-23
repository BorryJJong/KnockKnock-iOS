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
  func presentReportView()
  func presentBottomSheetView(
    isMyPost: Bool,
    deleteAction: (() -> Void)?,
    hideAction: (() -> Void)?,
    editAction: (() -> Void)?,
    reportAction: (() -> Void)?
 )
  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  )
}

final class FeedDetailRouter: FeedDetailRouterProtocol {
  
  weak var view: FeedDetailViewProtocol?
  
  static func createFeedDetail(feedId: Int) -> UIViewController {
    let view = FeedDetailViewController()
    let interactor = FeedDetailInteractor()
    let presenter = FeedDetailPresenter()
    let worker = FeedDetailWorker(
      feedRepository: FeedRepository(),
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
  
  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  ) {
    if let sourceView = self.view as? UIViewController {
      sourceView.showAlert(
        content: message,
        isCancelActive: false,
        confirmActionCompletion: confirmAction
      )
    }
  }

  func presentReportView() {
    guard let sourceView = self.view as? UIViewController else { return }
    let reportView = UINavigationController(rootViewController: ReportViewController())

    sourceView.present(reportView, animated: true)
  }
  
  func presentBottomSheetView(
    isMyPost: Bool,
    deleteAction: (() -> Void)?,
    hideAction: (() -> Void)?,
    editAction: (() -> Void)?,
    reportAction: (() -> Void)?
  ) {
    
    guard let bottomSheetViewController = BottomSheetRouter.createBottomSheet(
      deleteAction: deleteAction,
      hideAction: hideAction,
      editAction: editAction,
      reportAction: reportAction,
      isMyPost: isMyPost
    ) as? BottomSheetViewController else { return }
    
    if let sourceView = self.view as? UIViewController {
      sourceView.present(
        bottomSheetViewController,
        animated: false,
        completion: nil
      )
    }
  }
}
