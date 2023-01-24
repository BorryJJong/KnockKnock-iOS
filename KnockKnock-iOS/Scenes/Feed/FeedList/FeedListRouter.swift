//
//  FeedListRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/26.
//

import UIKit

protocol FeedListRouterProtocol {
  var view: FeedListViewProtocol? { get set }
  static func createFeedList(feedId: Int, challengeId: Int) -> UIViewController

  func presentBottomSheetView(isMyPost: Bool, deleteAction: (() -> Void)?, feedData: FeedShare?)
  func navigateToFeedMain()
  func navigateToFeedDetail(feedId: Int)
  func navigateToCommentView(feedId: Int)
  func navigateToLoginView()
}

final class FeedListRouter: FeedListRouterProtocol {
  weak var view: FeedListViewProtocol?

  static func createFeedList(feedId: Int, challengeId: Int) -> UIViewController {

    let view = FeedListViewController()
    let interactor = FeedListInteractor()
    let presenter = FeedListPresenter()
    let worker = FeedListWorker(
      feedRepository: FeedRepository(),
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

  func presentBottomSheetView(
    isMyPost: Bool,
    deleteAction: (() -> Void)?,
    feedData: FeedShare?
  ) {

    guard let bottomSheetViewController = BottomSheetRouter.createBottomSheet(
      deleteAction: deleteAction,
      feedData: feedData,
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
