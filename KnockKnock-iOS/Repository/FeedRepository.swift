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

  func requestChallengeTitles(completionHandler: @escaping ([ChallengeTitle]) -> Void) {
    KKNetworkManager.shared
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

  func requestFeedMain(
    currentPage: Int,
    totalCount: Int,
    challengeId: Int,
    completionHandler: @escaping (FeedMain) -> Void
  ) {

    KKNetworkManager.shared
      .request(
        object: FeedMain.self,
        router: KKRouter.getFeedMain(
          page: currentPage,
          take: totalCount,
          challengeId: challengeId
        ),
        success: { response in
          completionHandler(response)
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
    completionHandler: @escaping (FeedList) -> Void) {
      KKNetworkManager.shared
        .request(
          object: FeedList.self,
          router: KKRouter.getFeedBlogPost(
            page: currentPage,
            take: pageSize,
            feedId: feedId,
            challengeId: challengeId
          ),
          success: { response in
            completionHandler(response)
          },
          failure: { response in
            print(response)
          }
        )
    }

  // MARK: - Feed detail APIs

  func requestFeedDetail(
    feedId: Int,
    completionHandler: @escaping (FeedDetail) -> Void
  ) {
    KKNetworkManager.shared
      .request(
        object: FeedDetail.self,
        router: KKRouter.getFeed(id: feedId),
        success: { response in
          completionHandler(response)
        },
        failure: { response in
          print(response)
        }
      )
  }
}
