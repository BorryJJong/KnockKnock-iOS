//
//  MyRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/02.
//

import UIKit

protocol MyRouterProtocol {
  static func createMy() -> UIViewController

  func navigateToNoticeView(source: MyViewProtocol)
  func navigateToLoginView(source: MyViewProtocol)
  func navigateToProfileSettingView(source: MyViewProtocol)
}

final class MyRouter: MyRouterProtocol {
  static func createMy() -> UIViewController {
    let view = MyViewController()
    let interactor = MyInteractor()
    let router = MyRouter()

    view.interactor = interactor
    interactor.router = router

    return view
  }

  func navigateToLoginView(source: MyViewProtocol) {
    let loginViewController = LoginRouter.createLoginView()

    if let sourceView = source as? UIViewController {
      loginViewController.hidesBottomBarWhenPushed = true
      sourceView.navigationController?.pushViewController(loginViewController, animated: true)
    }
  }

  func navigateToNoticeView(source: MyViewProtocol) {
    let noticeViewController = NoticeRouter.createNoticeView()

    if let sourceView = source as? UIViewController {
      sourceView.navigationController?.pushViewController(
        noticeViewController,
        animated: true
      )
    }
  }

  func navigateToProfileSettingView(source: MyViewProtocol) {
    let profileViewController = ProfileSettingRouter.createProfileSettingView(loginInfo: nil)

    if let sourceView = source as? UIViewController {
      sourceView.navigationController?.pushViewController(
        profileViewController,
        animated: true
      )
    }
  }
}
