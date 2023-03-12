//
//  HotPostRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/17.
//

import Foundation

protocol HotPostRepositoryProtocol {
  func requestHotPost(
    challengeId: Int,
    completionHandler: @escaping (ApiResponse<[HotPost]>?) -> Void
  )
  func requestChallengeTitles(
    completionHandler: @escaping (ApiResponse<[ChallengeTitle]>?) -> Void
  )
}

final class HotPostRepository: HotPostRepositoryProtocol {

  /// 인기 게시글 조회
  func requestHotPost(
    challengeId: Int,
    completionHandler: @escaping (ApiResponse<[HotPost]>?) -> Void
  ) {

    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<[HotPostDTO]>.self,
        router: KKRouter.getHotPost(challengeId: challengeId),
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.map { $0.toDomain() }
          )
          completionHandler(result)

        }, failure: { response, error in

          guard let response = response else {
            completionHandler(nil)
            return
          }

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.map { $0.toDomain() }
          )
          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }

  /// 태그 리스트(인기 게시글 필터용)
  func requestChallengeTitles(
    completionHandler: @escaping (ApiResponse<[ChallengeTitle]>?) -> Void
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<[ChallengeTitleDTO]>.self,
        router: KKRouter.getChallengeTitles,
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.map { $0.toDomain() }
          )
          completionHandler(result)

        }, failure: { response, error in

          guard let response = response else {
            completionHandler(nil)
            return
          }

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.map { $0.toDomain() }
          )
          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }
}
