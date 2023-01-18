//
//  FeedEditWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/18.
//

import UIKit

protocol FeedEditWorkerProtocol {
  func fetchOriginPost(feedId: Int, completionHandler: @escaping (FeedDetail) -> Void) 
}

final class FeedEditWorker: FeedEditWorkerProtocol {

  private let feedRepository: FeedRepositoryProtocol

  init(feedRepository: FeedRepositoryProtocol) {
    self.feedRepository = feedRepository
  }

  func fetchOriginPost(feedId: Int, completionHandler: @escaping (FeedDetail) -> Void) {
    self.feedRepository.requestFeedDetail(
      feedId: feedId,
      completionHandler: { feed in
        completionHandler(feed)
      }
    )
  }
}
