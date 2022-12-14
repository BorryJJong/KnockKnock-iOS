//
//  FeedWriteWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/18.
//

import Foundation

protocol FeedWriteWorkerProtocol: AnyObject {
  func uploadFeed(postData: FeedWrite, completionHandler: @escaping () -> Void)
  func checkEssentialField(imageCount: Int, tag: [ChallengeTitle], promotion: [Promotion], isContentFilled: Bool, completionHandler: @escaping (Bool) -> Void)
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

  func checkEssentialField(
    imageCount: Int,
    tag: [ChallengeTitle],
    promotion: [Promotion],
    isContentFilled: Bool,
    completionHandler: @escaping (Bool) -> Void
  ) {
    let isPromotionSelected = promotion.filter {
      $0.isSelected == true
    }.count != 0

    let isTagSelected = tag.filter{
      $0.isSelected == true
    }.count != 0

    let isImageSelected = imageCount != 0

    let result = isPromotionSelected && isTagSelected && isImageSelected && isContentFilled

    completionHandler(result)
   }
}
