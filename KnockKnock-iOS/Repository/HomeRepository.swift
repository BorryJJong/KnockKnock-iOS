//
//  HomeRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/17.
//

import Foundation

protocol HomeRepositoryProtocol {
  func requestHotPost(completionHandler: @escaping ([HotPost]) -> Void)
  func requestChallengeTitles(completionHandler: @escaping ([ChallengeTitle]) -> Void)
}

final class HomeRepository: HomeRepositoryProtocol {

  /// 인기 게시글 조회
  func requestHotPost(completionHandler: @escaping ([HotPost]) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<[HotPostDTO]>.self,
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

  /// 태그 리스트(인기 게시글 필터용)
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
        }
      )
  }
}
