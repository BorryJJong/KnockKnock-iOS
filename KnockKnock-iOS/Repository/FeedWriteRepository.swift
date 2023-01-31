//
//  FeedWriteRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/05.
//

import Foundation

protocol FeedWriteRepositoryProtocol {
  func requestChallengeTitles(completionHandler: @escaping (([ChallengeTitle])) -> Void)
  func requestPromotionList(completionHandler: @escaping ([Promotion]) -> Void)
  func requestFeedPost(postData: FeedWrite, completionHandler: @escaping () -> Void)
}

final class FeedWriteRepository: FeedWriteRepositoryProtocol {

  func requestChallengeTitles(completionHandler: @escaping ([ChallengeTitle]) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<[ChallengeTitleDTO]>.self,
        router: KKRouter.getChallengeTitles,
        success: { response in
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data.map{$0.toDomain()})
        }, failure: { error in
          print(error)
        })
  }

  func requestPromotionList(completionHandler: @escaping ([Promotion]) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<[PromotionDTO]>.self,
        router: KKRouter.getPromotions,
        success: { response in
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data.map{$0.toDomain()})
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
