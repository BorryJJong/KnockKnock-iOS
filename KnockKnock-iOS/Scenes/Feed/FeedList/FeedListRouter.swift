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
  func navigateToCommentView(feedId: Int, source: FeedListViewProtocol)
  func presentBottomSheetView(source: FeedListViewProtocol)
}

final class FeedListRouter: FeedListRouterProtocol {
  static func createFeedList(feedId: Int, challengeId: Int) -> UIViewController {

    let view = FeedListViewController()
    let interactor = FeedListInteractor()
    let presenter = FeedListPresenter()
    let worker = FeedListWorker(repository: FeedRepository())
    let router = FeedListRouter()

    view.interactor = interactor
    view.router = router
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

  func navigateToCommentView(feedId: Int, source: FeedListViewProtocol) {
    let commentViewController = CommentRouter.createCommentView(feedId: feedId)
    if let sourceView = source as? UIViewController {
      commentViewController.modalPresentationStyle = .fullScreen
      sourceView.present(commentViewController, animated: true, completion: nil)
    }
  }

  func presentBottomSheetView(source: FeedListViewProtocol) {
    let bottomSheetViewController = BottomSheetViewController().then {
      $0.setBottomSheetContents(
        contents: [
          BottomSheetOption.report.rawValue,
          BottomSheetOption.share.rawValue,
          BottomSheetOption.hide.rawValue
        ])
      $0.modalPresentationStyle = .overFullScreen
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
