//
//  MyRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/02.
//

import UIKit

protocol MyRouterProtocol {
  var view: MyViewProtocol? { get set }

  static func createMy() -> UIViewController

  func navigateToNoticeView()
  func navigateToLoginView()
  func navigateToProfileSettingView()
}

final class MyRouter: MyRouterProtocol {
  weak var view: MyViewProtocol?

  static func createMy() -> UIViewController {
    let view = MyViewController()
    let interactor = MyInteractor()
    let presenter = MyPresenter()
    let worker = MyWorker(
      userDataManager: UserDataManager(),
      accountManager: AccountManager()
    )
    let router = MyRouter()

    view.interactor = interactor
    interactor.router = router
    interactor.worker = worker
    interactor.presenter = presenter
    presenter.view = view
    router.view = view

    return view
  }

  func navigateToLoginView() {
    let loginViewController = LoginRouter.createLoginView()

    if let sourceView = self.view as? UIViewController {
      loginViewController.hidesBottomBarWhenPushed = true

      sourceView.navigationController?.pushViewController(
        loginViewController,
        animated: true
      )
    }
  }

  func navigateToNoticeView() {
    let noticeViewController = NoticeRouter.createNoticeView()

    if let sourceView = self.view as? UIViewController {
      sourceView.navigationController?.pushViewController(
        noticeViewController,
        animated: true
      )
    }
  }

  func navigateToProfileSettingView() {
    let profileViewController = ProfileSettingRouter.createProfileSettingView(
      profileSettingViewType: .update,
      signInInfo: nil
    )

    if let sourceView = self.view as? UIViewController {
      profileViewController.hidesBottomBarWhenPushed = true

      sourceView.navigationController?.pushViewController(
        profileViewController,
        animated: true
      )
    }
  }
}
