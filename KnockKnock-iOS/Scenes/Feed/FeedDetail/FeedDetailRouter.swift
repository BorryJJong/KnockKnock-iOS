//
//  FeedDetailRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import UIKit

protocol FeedDetailRouterProtocol {
  static func createFeedDetail(feedId: Int) -> UIViewController

  func navigateToLikeDetail(source: FeedDetailViewProtocol, like: [LikeInfo])
}

final class FeedDetailRouter: FeedDetailRouterProtocol {
  static func createFeedDetail(feedId: Int) -> UIViewController {
    let view = FeedDetailViewController()
    let interactor = FeedDetailInteractor()
    let presenter = FeedDetailPresenter()
    let worker = FeedDetailWorker(
      feedRepository: FeedRepository(),
      commentRepository: CommentRepository(),
      likeRepository: LikeRepository()
    )
    let router = FeedDetailRouter()

    view.feedId = feedId
    view.interactor = interactor
    interactor.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view

    return view
  }

  func navigateToLikeDetail(source: FeedDetailViewProtocol, like: [LikeInfo]) {
    let likeDetailViewController = LikeDetailViewContoller()
    if let sourceView = source as? UIViewController {
      likeDetailViewController.like = like
      sourceView.navigationController?.pushViewController(likeDetailViewController, animated: true)
    }
  }
}
