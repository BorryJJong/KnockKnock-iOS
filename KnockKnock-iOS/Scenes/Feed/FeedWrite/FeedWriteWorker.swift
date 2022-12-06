//
//  FeedWriteWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/18.
//

import Foundation

protocol FeedWriteWorkerProtocol: AnyObject {
  func uploadFeed(postData: FeedWrite, completionHandler: @escaping () -> Void)
}

final class FeedWriteWorker: FeedWriteWorkerProtocol {
  private let feedWriteRepository: FeedWriteRepositoryProtocol

  init(feedWriteRepository: FeedWriteRepositoryProtocol) {
    self.feedWriteRepository = feedWriteRepository
  }

  func uploadFeed(
    postData: FeedWrite,
    completionHandler: @escaping () -> Void
  ) {
    self.feedWriteRepository.requestFeedPost(
      postData: postData,
      completionHandler: {
        completionHandler()
      }
    )
  }
}
