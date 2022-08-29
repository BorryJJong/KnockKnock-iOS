//
//  CommentRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import UIKit

protocol CommentRouterProtocol {
  static func createCommentView() -> UIViewController
  func dismissCommentView(view: CommentViewProtocol)
  func presentBottomSheetView(source: CommentViewProtocol)
}

final class CommentRouter: CommentRouterProtocol {
  
  static func createCommentView() -> UIViewController {
    let view = CommentViewController()
    let interactor = CommentInteractor()
    let presenter = CommentPresenter()
    let worker = CommentWorker(repository: CommentRepository())
    let router = CommentRouter()
    
    view.router = router
    view.interactor = interactor
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
          BottomSheetOption.delete.rawValue,
          BottomSheetOption.edit.rawValue
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
