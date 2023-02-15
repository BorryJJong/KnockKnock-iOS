//
//  EventDetailWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/15.
//

import UIKit

protocol EventDetailWorkerProtocol {
  func fetchEventDetailList(eventTapType: EventTapType) async -> [EventDetail]?
}

final class EventDetailWorker: EventDetailWorkerProtocol {

  // MARK: - Properties

  private let homeRepository: HomeRepositoryProtocol

  // MARK: - Initialize

  init(homeRepository: HomeRepositoryProtocol) {
    self.homeRepository = homeRepository
  }

  func fetchEventDetailList(eventTapType: EventTapType) async -> [EventDetail]? {
    
    return await self.homeRepository.requestEventDetailList(eventTapType: eventTapType)

  }
}
