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
  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  )
}

final class CommentRouter: CommentRouterProtocol {
  weak var view: CommentViewProtocol?

  static func createCommentView(feedId: Int) -> UIViewController {
    let view = CommentViewController()
    let interactor = CommentInteractor()
    let presenter = CommentPresenter()
    let worker = CommentWorker(repository: CommentRepository())
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

  /// AlertView
  ///
  /// - Parameters:
  ///  - message: 알림창 메세지
  ///  - confirmAction: 확인 눌렀을 때 수행 될 액션
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
}
