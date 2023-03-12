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
  func requestFeedPost(postData: FeedWrite, completionHandler: @escaping (Int?) -> Void)
}

final class FeedWriteRepository: FeedWriteRepositoryProtocol {

  func requestChallengeTitles(completionHandler: @escaping ([ChallengeTitle]) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<[ChallengeTitleDTO]>.self,
        router: KKRouter.getChallengeTitles,
        success: { response in
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data.map{$0.toDomain()})
        }, failure: { response, error in
          print(error)
        }
      )
  }

  func requestPromotionList(completionHandler: @escaping ([Promotion]) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<[PromotionDTO]>.self,
        router: KKRouter.getPromotions,
        success: { response in
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data.map{$0.toDomain()})
        },
        failure: { response, error in
          print(error)
        }
      )
  }

  func requestFeedPost(
    postData: FeedWrite,
    completionHandler: @escaping (Int?) -> Void
  ) {
    KKNetworkManager
      .shared
      .upload(
        object: ApiResponse<FeedWriteDTO>.self,
        router: KKRouter.postFeed(postData: postData),
        success: { response in
          completionHandler(response.data?.id)
        },
        failure: { response, error in
          print(error)
        }
      )
  }
}
