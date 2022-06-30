//
//  FeedRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/23.
//

import Foundation

import Alamofire

protocol FeedRepositoryProtocol {
  func fetchFeed(completionHandler: @escaping ([Feed]) -> Void)
  func getChallengeTitles(completionHandler: @escaping (([ChallengeTitle])) -> Void)
}

final class FeedRepository: FeedRepositoryProtocol {
  func getChallengeTitles(completionHandler: @escaping (([ChallengeTitle])) -> Void) {
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

  //  func fetchFeed(completionHandler: @escaping ([Feed]) -> Void) {
  //    KKNetworkManager.shared
  //      .request(
  //        object: [Feed].self,
  //        router: KKRouter.fetchFeed,
  //        success: { response in
  //          completionHandler(response)
  //        },
  //        failure: { response in
  //          print(response)
  //        })
  //  }

  // api 미완성으로 우선 dummydata 사용
  func fetchFeed(completionHandler: @escaping ([Feed]) -> Void) {
    let feed = [Feed(userId: 1, content: "패키지 상품을 받았을때의 기쁨 후엔 늘 골치아픈 쓰레기와 분리수거의 노동시간이 뒤따릅니다. 패키지 상품을 받았을때의 기쁨 후엔 늘 골치아픈 쓰레기와 분리수거의 노동시간이 뒤따릅니다. ", images: ["feed_sample_1"], scale: "1:1"),
                Feed(userId: 2, content: "b패키지 상품을 받았을때의 기쁨 후엔 늘 골치아픈 쓰레기와 분리수거의 노동시간이 뒤따릅니다. 패키지 상품을 받았을때의 기쁨 후엔 늘 골치아픈 쓰레기와 분리수거의 노동시간이 뒤따릅니다. 패키지 상품을 받았을때의 기쁨 후엔 늘 골치아픈 쓰레기와 분리수거의 노동시간이 뒤따릅니다. 패키지 상품을 받았을때의 기쁨 후엔 늘 골치아픈 쓰레기와 분리수거의 노동시간이 뒤따릅니다. b", images: ["feed_sample_4"], scale: "1:1"),
                Feed(userId: 3, content: "aa", images: ["feed_sample_2"], scale: "3:4"),
                Feed(userId: 4, content: "bb", images: ["feed_sample_3"], scale: "1:1"),
                Feed(userId: 5, content: "aa", images: ["feed_sample_4", "feed_sample_2", "feed_sample_2"], scale: "4:3"),
                Feed(userId: 6, content: "bb", images: ["feed_sample_2"], scale: "1:1"),
                Feed(userId: 7, content: "aa", images: ["feed_sample_2", "feed_sample_2", "feed_sample_2"], scale: "1:1"),
                Feed(userId: 8, content: "bb", images: ["challenge"], scale: "1:1"),
                Feed(userId: 9, content: "aa", images: ["challenge", "challenge", "challenge"], scale: "4:3"),
                Feed(userId: 10, content: "bb", images: ["challenge"], scale: "1:1"),
                Feed(userId: 11, content: "aa", images: ["challenge", "challenge", "challenge"], scale: "1:1"),
                Feed(userId: 12, content: "bb", images: ["challenge"], scale: "1:1"),
                Feed(userId: 13, content: "aa", images: ["challenge", "challenge", "challenge"], scale: "1:1"),
                Feed(userId: 14, content: "bb", images: ["challenge"], scale: "1:1"),
                Feed(userId: 15, content: "aa", images: ["challenge", "challenge", "challenge"], scale: "1:1"),
                Feed(userId: 16, content: "bb", images: ["challenge"], scale: "1:1")]
    completionHandler(feed)
  }
}
