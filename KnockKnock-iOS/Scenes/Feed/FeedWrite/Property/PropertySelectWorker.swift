//
//  PropertySelectWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/04.
//

import UIKit

protocol PropertySelectWorkerProtocol {
  func requestPromotionList(completionHandler: @escaping ([Promotion]) -> Void)
}

final class PropertySelectWorker: PropertySelectWorkerProtocol {
  private let repository: FeedRepositoryProtocol?

  init(repository: FeedRepositoryProtocol) {
    self.repository = repository
  }

  func requestPromotionList(completionHandler: @escaping ([Promotion]) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: [Promotion].self,
        router: KKRouter.getPromotions,
        success: { response in
          completionHandler(response)
        },
        failure: { error in
          print(error)
        }
      )
  }

}
