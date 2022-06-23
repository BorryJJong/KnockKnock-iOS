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
}

final class FeedRepository: FeedRepositoryProtocol {
  //
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
    let feed = [Feed(userId: 1, content: "aa", images: ["challenge", "challenge", "challenge"]),
                Feed(userId: 2, content: "bb", images: ["challenge"]),
                Feed(userId: 3, content: "aa", images: ["challenge", "challenge", "challenge"]),
                Feed(userId: 4, content: "bb", images: ["challenge"]),
                Feed(userId: 5, content: "aa", images: ["challenge", "challenge", "challenge"]),
                Feed(userId: 6, content: "bb", images: ["challenge"]),
                Feed(userId: 7, content: "aa", images: ["challenge", "challenge", "challenge"]),
                Feed(userId: 8, content: "bb", images: ["challenge"]),
                Feed(userId: 9, content: "aa", images: ["challenge", "challenge", "challenge"]),
                Feed(userId: 10, content: "bb", images: ["challenge"]),
                Feed(userId: 11, content: "aa", images: ["challenge", "challenge", "challenge"]),
                Feed(userId: 12, content: "bb", images: ["challenge"]),
                Feed(userId: 13, content: "aa", images: ["challenge", "challenge", "challenge"]),
                Feed(userId: 14, content: "bb", images: ["challenge"]),
                Feed(userId: 15, content: "aa", images: ["challenge", "challenge", "challenge"]),
                Feed(userId: 16, content: "bb", images: ["challenge"])]
    completionHandler(feed)
  }
}
