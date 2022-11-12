//
//  PropertySelectWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/04.
//

import UIKit

protocol PropertySelectWorkerProtocol {
  func requestPromotionList(completionHandler: @escaping ([PromotionInfo]) -> Void)
  func requestTagList(completionHandler: @escaping ([ChallengeTitle]) -> Void)
}

final class PropertySelectWorker: PropertySelectWorkerProtocol {
  private let repository: FeedRepositoryProtocol?

  init(repository: FeedRepositoryProtocol) {
    self.repository = repository
  }

  func requestPromotionList(completionHandler: @escaping ([PromotionInfo]) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: [PromotionInfo].self,
        router: KKRouter.getPromotions,
        success: { response in
          completionHandler(response)
        }, failure: { error in
          print(error)
        }
      )
  }

  func requestTagList(completionHandler: @escaping ([ChallengeTitle]) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: [ChallengeTitle].self,
        router: KKRouter.getChallengeTitles,
        success: { response in
          completionHandler(response)
        }, failure: { error in
          print(error)
        }
      )
  }
}
