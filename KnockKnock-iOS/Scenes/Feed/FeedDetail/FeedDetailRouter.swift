//
//  FeedDetailRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import UIKit

protocol FeedDetailRouterProtocol {
  static func createFeedDetail() -> UIViewController
}

final class FeedDetailRouter: FeedDetailRouterProtocol {
  static func createFeedDetail() -> UIViewController {
    let view = FeedDetailViewController()
    let interactor = FeedDetailInteractor()
    let presenter = FeedDetailPresenter()
    let worker = FeedDetailWorker(
      feedRepository: FeedRepository(),
      commentRepository: CommentRepository(),
      likeRepository: LikeRepository()
    )
    let router = FeedDetailRouter()

    view.interactor = interactor
    view.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view

    return view
  }
}
