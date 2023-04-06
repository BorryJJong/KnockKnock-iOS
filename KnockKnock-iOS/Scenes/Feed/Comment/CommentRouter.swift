//
//  CommentRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import UIKit

protocol CommentRouterProtocol {
  var view: CommentViewProtocol? { get set }

  static func createCommentView(feedId: Int) -> UIViewController

  func dismissCommentView()
}

final class CommentRouter: CommentRouterProtocol {
  weak var view: CommentViewProtocol?

  static func createCommentView(feedId: Int) -> UIViewController {
    let view = CommentViewController()
    let interactor = CommentInteractor()
    let presenter = CommentPresenter()
    let worker = CommentWorker(
      commentRepository: CommentRepository(),
      userDataManager: UserDataManager()
    )
    let router = CommentRouter()

    view.interactor = interactor
    view.feedId = feedId
    interactor.presenter = presenter
    interactor.worker = worker
    interactor.router = router
    presenter.view = view
    router.view = view

    return view
  }

  func dismissCommentView() {
    if let view = self.view as? UIViewController {
      view.dismiss(animated: true)
    }
  }
}
