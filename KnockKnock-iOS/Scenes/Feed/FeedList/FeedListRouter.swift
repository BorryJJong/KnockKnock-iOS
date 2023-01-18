//
//  FeedListRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/26.
//

import UIKit

protocol FeedListRouterProtocol {
  static func createFeedList(feedId: Int, challengeId: Int) -> UIViewController

  func navigateToFeedMain(source: FeedListViewProtocol)
  func navigateToFeedDetail(source: FeedListViewProtocol, feedId: Int)
  func navigateToFeedEdit(source: FeedListViewProtocol, feedId: Int)
  func navigateToCommentView(feedId: Int, source: FeedListViewProtocol)
  func navigateToLoginView(source: FeedListViewProtocol)
  func presentBottomSheetView(source: FeedListViewProtocol, isMyPost: Bool, deleteAction: (() -> Void)?, editAction: (() -> Void)?)
}

final class FeedListRouter: FeedListRouterProtocol {
  static func createFeedList(feedId: Int, challengeId: Int) -> UIViewController {

    let view = FeedListViewController()
    let interactor = FeedListInteractor()
    let presenter = FeedListPresenter()
    let worker = FeedListWorker(
      feedRepository: FeedRepository(),
      likeRepository: LikeRepository(),
      localDataManager: UserDataManager()
    )
    let router = FeedListRouter()

    view.interactor = interactor
    interactor.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view

    view.feedId = feedId
    view.challengeId = challengeId

    return view
  }

  func navigateToFeedMain(source: FeedListViewProtocol) {
    if let sourceView = source as? UIViewController {
      sourceView.navigationController?.popViewController(animated: true)
    }
  }

  func navigateToFeedDetail(source: FeedListViewProtocol, feedId: Int) {
    let feedDetailViewController = FeedDetailRouter.createFeedDetail(feedId: feedId)
    if let sourceView = source as? UIViewController {
      feedDetailViewController.hidesBottomBarWhenPushed = true
      sourceView.navigationController?.pushViewController(feedDetailViewController, animated: true)
    }
  }

  func navigateToFeedEdit(source: FeedListViewProtocol, feedId: Int) {
    let feedEditViewController = FeedEditRouter.createFeedEdit(feedId: feedId)
    if let sourceView = source as? UIViewController {
      feedEditViewController.hidesBottomBarWhenPushed = true
      sourceView.navigationController?.pushViewController(feedEditViewController, animated: true)
    }
  }

  func navigateToCommentView(feedId: Int, source: FeedListViewProtocol) {
    let commentViewController = CommentRouter.createCommentView(feedId: feedId)
    if let sourceView = source as? UIViewController {
      commentViewController.modalPresentationStyle = .fullScreen
      sourceView.present(commentViewController, animated: true, completion: nil)
    }
  }

  func navigateToLoginView(source: FeedListViewProtocol) {
    let loginViewController = LoginRouter.createLoginView()
    
    loginViewController.hidesBottomBarWhenPushed = true
    if let sourceView = source as? UIViewController {
      sourceView.navigationController?.pushViewController(loginViewController, animated: true)
    }
  }

  func presentBottomSheetView(
    source: FeedListViewProtocol,
    isMyPost: Bool,
    deleteAction: (() -> Void)?,
    editAction: (() -> Void)?
  ) {
    let bottomSheetViewController = BottomSheetViewController().then {
      if isMyPost {
        $0.setBottomSheetContents(
          contents: [
            BottomSheetOption.postDelete.rawValue,
            BottomSheetOption.postEdit.rawValue
          ],
          bottomSheetType: .small
        )

      } else {
        $0.setBottomSheetContents(
          contents: [
            BottomSheetOption.postReport.rawValue,
            BottomSheetOption.postShare.rawValue,
            BottomSheetOption.postHide.rawValue
          ],
          bottomSheetType: .medium
        )
      }
      $0.modalPresentationStyle = .overFullScreen
      $0.deleteAction = deleteAction
      $0.editAction = editAction
    }

    if let sourceView = source as? UIViewController {
      sourceView.present(
        bottomSheetViewController,
        animated: false,
        completion: nil
      )
    }
  }
}
