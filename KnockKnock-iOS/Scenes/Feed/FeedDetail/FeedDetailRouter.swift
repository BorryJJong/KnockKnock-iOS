//
//  FeedDetailRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import UIKit

protocol FeedDetailRouterProtocol {
  var view: FeedDetailViewProtocol? { get set }

  static func createFeedDetail(feedId: Int) -> UIViewController

  func navigateToLikeDetail(like: [Like.Info])
  func navigateToLoginView()
  func navigateToFeedList()
  func presentBottomSheetView(isMyPost: Bool, deleteAction: (() -> Void)?)
}

final class FeedDetailRouter: FeedDetailRouterProtocol {

  weak var view: FeedDetailViewProtocol?

  static func createFeedDetail(feedId: Int) -> UIViewController {
    let view = FeedDetailViewController()
    let interactor = FeedDetailInteractor()
    let presenter = FeedDetailPresenter()
    let worker = FeedDetailWorker(
      feedRepository: FeedRepository(),
      commentRepository: CommentRepository(),
      likeRepository: LikeRepository(),
      userDataManager: UserDataManager()
    )
    let router = FeedDetailRouter()

    view.feedId = feedId
    view.interactor = interactor
    interactor.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view
    router.view = view

    return view
  }

  func navigateToLikeDetail(like: [Like.Info]) {
    let likeDetailViewController = LikeDetailViewContoller()
    if let sourceView = self.view as? UIViewController {
      likeDetailViewController.like = like
      sourceView.navigationController?.pushViewController(likeDetailViewController, animated: true)
    }
  }

  func navigateToFeedList() {
    if let sourceView = self.view as? UIViewController {
      sourceView.navigationController?.popViewController(animated: true)
    }
  }

  func navigateToLoginView() {
    let loginViewController = LoginRouter.createLoginView()

    loginViewController.hidesBottomBarWhenPushed = true
    if let sourceView = self.view as? UIViewController {
      sourceView.navigationController?.pushViewController(loginViewController, animated: true)
    }
  }

  func presentBottomSheetView(isMyPost: Bool, deleteAction: (() -> Void)?) {
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
    }
    if let sourceView = self.view as? UIViewController {
      sourceView.present(
        bottomSheetViewController,
        animated: false,
        completion: nil
      )
    }
  }
}
