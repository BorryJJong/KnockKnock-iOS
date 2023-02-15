//
//  EventDetailRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/15.
//

import UIKit

protocol EventDetailRouterProtocol {
  static func createEventDetail() -> UIViewController
}

final class EventDetailRouter: EventDetailRouterProtocol {

  static func createEventDetail() -> UIViewController {
    let view = EventDetailViewController()
    let interactor = EventDetailInteractor()
    let presenter = EventDetailPresenter()
    let worker = EventDetailWorker()
    let router = EventDetailRouter()

    view.interactor = interactor
    interactor.router = router
    interactor.worker = worker
    interactor.presenter = presenter
    presenter.view = view

    return view
  }
}
