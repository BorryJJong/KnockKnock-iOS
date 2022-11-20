//
//  NoticeRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/31.
//

import UIKit

protocol NoticeRouterProtocol {
  static func createNoticeView() -> UIViewController
}

final class NoticeRouter: NoticeRouterProtocol {
  static func createNoticeView() -> UIViewController {
    let view = NoticeViewController()
    let router = NoticeRouter()

    view.router = router

    return view
  }
}
