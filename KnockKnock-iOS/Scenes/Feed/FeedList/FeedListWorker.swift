//
//  FeedListWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/26.
//

import UIKit

protocol FeedListWorkerProtocol {
  func fetchFeed(completionHandler: @escaping ([Feed]) -> Void)
}

final class FeedListWorker: FeedListWorkerProtocol {

  private let repository: FeedRepositoryProtocol

  init(repository: FeedRepositoryProtocol) {
    self.repository = repository
  }

  func fetchFeed(completionHandler: @escaping ([Feed]) -> Void) {
    repository.fetchFeed(completionHandler: { result in
      completionHandler(result)
    })
  }
}
