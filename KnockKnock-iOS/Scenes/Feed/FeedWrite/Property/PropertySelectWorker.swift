//
//  PropertySelectWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/04.
//

import Foundation

protocol PropertySelectWorkerProtocol {
  func requestPromotionList(
    completionHandler: @escaping (ApiResponse<[Promotion]>?) -> Void
  )
  func requestTagList(
    completionHandler: @escaping (ApiResponse<[ChallengeTitle]>?) -> Void
  )
}

final class PropertySelectWorker: PropertySelectWorkerProtocol {
  private let repository: FeedWriteRepositoryProtocol?

  init(repository: FeedWriteRepositoryProtocol) {
    self.repository = repository
  }

  func requestPromotionList(
    completionHandler: @escaping (ApiResponse<[Promotion]>?) -> Void
  ) {
    self.repository?.requestPromotionList(
      completionHandler: { response in
        completionHandler(response)
      }
    )
  }

  func requestTagList(
    completionHandler: @escaping (ApiResponse<[ChallengeTitle]>?) -> Void
  ) {
    self.repository?.requestChallengeTitles(
      completionHandler: { response in
        completionHandler(response)
      }
    )
  }
}
