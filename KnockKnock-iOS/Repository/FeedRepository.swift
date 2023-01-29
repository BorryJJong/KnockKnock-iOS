//
//  FeedRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/23.
//

import Foundation
import Alamofire

protocol FeedRepositoryProtocol {
  func requestFeedMain(
    currentPage: Int,
    totalCount: Int,
    challengeId: Int,
    completionHandler: @escaping (FeedMain) -> Void
  )
  func requestDeleteFeed(feedId: Int, completionHandler: @escaping (Bool) -> Void)
  func requestChallengeTitles(completionHandler: @escaping ([ChallengeTitle]) -> Void)
  func requestFeedDetail(feedId: Int, completionHandler: @escaping (FeedDetail) -> Void)
  func requestFeedList(
    currentPage: Int,
    pageSize: Int,
    feedId: Int,
    challengeId: Int,
    completionHandler: @escaping (FeedList) -> Void
  )
}

final class FeedRepository: FeedRepositoryProtocol {

  // MARK: - Feed main APIs

  func requestChallengeTitles(
    completionHandler: @escaping ([ChallengeTitle]) -> Void
  ) {

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
        }
      )
  }

  func requestFeedMain(
    currentPage: Int,
    totalCount: Int,
    challengeId: Int,
    completionHandler: @escaping (FeedMain) -> Void
  ) {

    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<FeedMain>.self,
        router: KKRouter.getFeedMain(
          page: currentPage,
          take: totalCount,
          challengeId: challengeId
        ),
        success: { response in
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data)
        },
        failure: { response in
          print(response)
        }
      )
  }

  // MARK: - Feed list APIs

  func requestFeedList(
    currentPage: Int,
    pageSize: Int,
    feedId: Int,
    challengeId: Int,
    completionHandler: @escaping (FeedList) -> Void
  ) {

      KKNetworkManager
        .shared
        .request(
          object: ApiResponseDTO<FeedList>.self,
          router: KKRouter.getFeedBlogPost(
            page: currentPage,
            take: pageSize,
            feedId: feedId,
            challengeId: challengeId
          ),
          success: { response in
            guard let data = response.data else {
              // no data error
              return
            }
            completionHandler(data)
          },
          failure: { response in
            print(response)
          }
        )
    }

  func requestDeleteFeed(
    feedId: Int,
    completionHandler: @escaping (Bool) -> Void
  ) {

    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<Bool>.self,
        router: KKRouter.deleteFeed(id: feedId),
        success: { response in
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data)
        }, failure: { error in
          print(error)
        }
      )
  }

  // MARK: - Feed detail APIs

  func requestFeedDetail(
    feedId: Int,
    completionHandler: @escaping (FeedDetail) -> Void
  ) {
    
    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<FeedDetail>.self,
        router: KKRouter.getFeed(id: feedId),
        success: { response in
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data)
        },
        failure: { response in
          print(response)
        }
      )
  }
}
