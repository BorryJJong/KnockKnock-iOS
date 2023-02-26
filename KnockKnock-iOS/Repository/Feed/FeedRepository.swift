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

  func requestChallengeTitles(
    completionHandler: @escaping ([ChallengeTitle]) -> Void
  )
}

final class FeedRepository: FeedRepositoryProtocol {

  typealias OnCompletionHandler = (Bool) -> Void

  // MARK: - Feed main APIs

  func requestChallengeTitles(
    completionHandler: @escaping ([ChallengeTitle]) -> Void
  ) {

    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<[ChallengeTitleDTO]>.self,
        router: .getChallengeTitles,
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
        router: .getFeedMain(
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
}
