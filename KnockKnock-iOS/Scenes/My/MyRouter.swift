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
}

final class MyRouter: MyRouterProtocol {
  static func createMy() -> UIViewController {
    let view = MyViewController()
    let router = MyRouter()

    view.router = router

    return view
  }

  func navigateToLoginView(source: MyViewProtocol) {
    let loginViewController = LoginRouter.createLoginView()

    if let sourceView = source as? UIViewController {
      loginViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
      sourceView.present(loginViewController, animated: true)
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
}