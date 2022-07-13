//
//  CommentRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import UIKit

protocol CommentRouterProtocol {
  static func createCommentView() -> UIViewController
}

final class CommentRouter: CommentRouterProtocol {

  static func createCommentView() -> UIViewController {
    let view = CommentViewController()
    let interactor = CommentInteractor()
    let presenter = CommentPresenter()
    let worker = CommentWorker()
    let router = CommentRouter()

    view.router = router
    view.interactor = interactor
    interactor.presenter = presenter
    interactor.worker = worker
//    presenter.view = view

    return view
  }
}
