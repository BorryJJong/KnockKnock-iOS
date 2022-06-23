//
//  FeedWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import Foundation

protocol FeedWorkerProtocol: AnyObject {
  func fetchFeed(completionHandler: @escaping ([Feed]) -> Void)
}

final class FeedWorker: FeedWorkerProtocol {

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
