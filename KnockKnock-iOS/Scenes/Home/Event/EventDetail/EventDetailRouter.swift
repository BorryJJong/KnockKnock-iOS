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
    let ongoingEventListViewController = OngoingEventListViewController()
    let closedEventListViewController = ClosedEventListViewController()

    ongoingEventListViewController.repository = HomeRepository()
    closedEventListViewController.repository = HomeRepository()

    view.eventViewControllers = [
      ongoingEventListViewController,
      closedEventListViewController
    ]

    return view
  }
}
