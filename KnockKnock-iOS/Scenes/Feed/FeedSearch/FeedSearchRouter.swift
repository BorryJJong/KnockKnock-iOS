//
//  FeedSearchRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/14.
//

import UIKit

protocol FeedSearchRouterProtocol {
  static func createFeedSearch(searchLog: [SearchLog]) -> UIViewController

}

final class FeedSearchRouter: FeedSearchRouterProtocol {
  static func createFeedSearch(searchLog: [SearchLog]) -> UIViewController {
    let view = FeedSearchViewController()
    let interactor = FeedSearchInteractor()
    let presenter = FeedSearchPresenter()
    let worker = FeedSearchWorker()
    let router = FeedSearchRouter()

    view.interactor = interactor
    view.router = router
    view.searchLog = searchLog
    interactor.presenter = presenter
    interactor.worker = worker
    
    return view
  }
}
