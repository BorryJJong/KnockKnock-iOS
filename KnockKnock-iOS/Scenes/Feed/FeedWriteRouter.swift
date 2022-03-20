//
//  FeedWriteRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/18.
//

import Foundation
import UIKit

protocol FeedWriteRouterProtocol: AnyObject {
  static func createFeedWrite() -> UIViewController
}

final class FeedWriteRouter: FeedWriteRouterProtocol {
  static func createFeedWrite() -> UIViewController {
    let view = FeedWriteViewController()
    let interactor = FeedWriteInteractor()
    let presenter = FeedWritePresenter()
    let worker = FeedWriteWorker()

    view.interactor = interactor
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view

    return view
  }
}
