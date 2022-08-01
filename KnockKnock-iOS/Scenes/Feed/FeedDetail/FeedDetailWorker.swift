//
//  FeedDetailWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import UIKit

protocol FeedDetailWorkerProtocol {
  func getFeedDetail(complitionHandler: @escaping (FeedDetail) -> Void)
  func getAllComments(complitionHandler: @escaping ([Comment]) -> Void)
}

final class FeedDetailWorker: FeedDetailWorkerProtocol {

  private let feedRepository: FeedRepositoryProtocol
  private let commentRepository: CommentRepositoryProtocol

  init(
    feedRepository: FeedRepositoryProtocol,
    commentRepository: CommentRepositoryProtocol
  ) {
    self.feedRepository = feedRepository
    self.commentRepository = commentRepository
  }

  func getFeedDetail(complitionHandler: @escaping (FeedDetail) -> Void) {
    self.feedRepository.getFeedDetail(completionHandler: { feed in
      complitionHandler(feed)
    })
  }

  func getAllComments(complitionHandler: @escaping (([Comment]) -> Void)) {
    self.commentRepository.getComments(completionHandler: { comment in
      complitionHandler(comment)
    })
  }
}
