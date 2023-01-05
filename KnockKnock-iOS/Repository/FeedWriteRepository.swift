//
//  FeedWriteRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/05.
//

import Foundation

protocol FeedWriteRepositoryProtocol {
  func requestChallengeTitles(completionHandler: @escaping (([ChallengeTitle])) -> Void)
  func requestPromotionList(completionHandler: @escaping ([PromotionInfo]) -> Void)
  func requestFeedPost(postData: FeedWrite, completionHandler: @escaping () -> Void)
}

final class FeedWriteRepository: FeedWriteRepositoryProtocol {

  func requestChallengeTitles(completionHandler: @escaping ([ChallengeTitle]) -> Void) {
    KKNetworkManager.shared
      .request(
        object: [ChallengeTitle].self,
        router: KKRouter.getChallengeTitles,
        success: { response in
          completionHandler(response)
        }, failure: { error in
          print(error)
        })
  }

  func requestPromotionList(completionHandler: @escaping ([PromotionInfo]) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: [PromotionInfo].self,
        router: KKRouter.getPromotions,
        success: { response in
          completionHandler(response)
        },
        failure: { error in
          print(error)
        }
      )
  }

  func requestFeedPost(
    postData: FeedWrite,
    completionHandler: @escaping () -> Void
  ) {
    KKNetworkManager
      .shared
      .upload(
        object: FeedWriteDTO.self,
        router: KKRouter.postFeed(postData: postData),
        success: { _ in
          completionHandler()
        },
        failure: { error in
          print(error)
        }
      )
  }
}
