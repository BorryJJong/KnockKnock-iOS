//
//  CommentRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import UIKit

protocol CommentRouterProtocol {
  static func createCommentView(feedId: Int) -> UIViewController
  func dismissCommentView(view: CommentViewProtocol)
  func presentBottomSheetView(source: CommentViewProtocol)
  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  )
}

final class CommentRouter: CommentRouterProtocol {
  
  static func createCommentView(feedId: Int) -> UIViewController {
    let view = CommentViewController()
    let interactor = CommentInteractor()
    let presenter = CommentPresenter()
    let worker = CommentWorker(repository: CommentRepository())
    let router = CommentRouter()
    
    view.router = router
    view.interactor = interactor
    view.feedId = feedId
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view
    
    return view
  }
  
  func dismissCommentView(view: CommentViewProtocol) {
    if let view = view as? UIViewController {
      view.dismiss(animated: true)
    }
  }
  
  func presentBottomSheetView(source: CommentViewProtocol) {
    let bottomSheetViewController = BottomSheetViewController().then {
      $0.setBottomSheetContents(
        contents: [
          BottomSheetOption.postDelete.rawValue,
          BottomSheetOption.postEdit.rawValue
        ],
        bottomSheetType: .small
      )
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

  /// AlertView
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
