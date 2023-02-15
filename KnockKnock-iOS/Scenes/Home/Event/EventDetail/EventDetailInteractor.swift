//
//  EventDetailInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/15.
//

import UIKit

protocol EventDetailInteractorProtocol: AnyObject {
  var router: EventDetailRouterProtocol? { get set }
  var worker: EventDetailWorkerProtocol? { get set }
  var presenter: EventDetailPresenterProtocol? { get set }

  func fetchEventDetailList()
}

final class EventDetailInteractor: EventDetailInteractorProtocol {

  // MARK: - Properties

  var router: EventDetailRouterProtocol?
  var worker: EventDetailWorkerProtocol?
  var presenter: EventDetailPresenterProtocol?

  private var ongoingEventList: [EventDetail] = []
  private var endEventList: [EventDetail] = []

  // MARK: - Business Logic

  func fetchEventDetailList() {
    Task {
      guard let ongoingEventList = await self.worker?.fetchEventDetailList(
        eventTapType: .ongoing
      ) else {
        // error
        return
      }

      guard let endEventList = await self.worker?.fetchEventDetailList(eventTapType: .end) else {
        return

      }

      self.ongoingEventList = ongoingEventList
      self.endEventList = endEventList

    }
  }

  // MARK: - Routing

}
