//
//  FeedDetailWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import UIKit

protocol FeedDetailWorkerProtocol {
  func getFeedDetail(complitionHandler: @escaping (FeedDetail) -> Void)
}

final class FeedDetailWorker: FeedDetailWorkerProtocol {

  private let repository: FeedRepositoryProtocol

  init(repository: FeedRepositoryProtocol) {
    self.repository = repository
  }

  func getFeedDetail(complitionHandler: @escaping (FeedDetail) -> Void) {
    repository.getFeedDetail(completionHandler: { result in
      complitionHandler(result)
    })
  }
}
