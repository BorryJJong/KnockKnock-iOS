//
//  FeedSearchRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/14.
//

import UIKit

protocol FeedSearchRouterProtocol {
  static func createFeedSearch() -> UIViewController

}

final class FeedSearchRouter: FeedSearchRouterProtocol {
  static func createFeedSearch() -> UIViewController {
    let view = FeedSearchViewController()
    let interactor = FeedSearchInteractor()
    let presenter = FeedSearchPresenter()
    let worker = FeedSearchWorker()
    let router = FeedSearchRouter()

    view.interactor = interactor
    view.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    
    return view
  }
}
