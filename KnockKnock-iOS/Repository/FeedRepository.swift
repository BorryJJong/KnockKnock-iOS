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
  func requestChallengeTitles(completionHandler: @escaping (([ChallengeTitle])) -> Void)
  func getFeedDetail(completionHandler: @escaping (FeedDetail) -> Void)
  func requestFeedList(
    currentPage: Int,
    count: Int,
    feedId: Int,
    challengeId: Int,
    completionHandler: @escaping (FeedList) -> Void
  )
//  func fetchFeed(completionHandler: @escaping ([Feed]) -> Void)
}

final class FeedRepository: FeedRepositoryProtocol {

  // MARK: - Feed main APIs

  func requestChallengeTitles(completionHandler: @escaping (([ChallengeTitle])) -> Void) {
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

    func requestFeedMain(
      currentPage: Int,
      totalCount: Int,
      challengeId: Int,
      completionHandler: @escaping (FeedMain) -> Void) {
        
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
          })
    }

  // MARK: - Feed list APIs

  func requestFeedList(
    currentPage: Int,
    count: Int,
    feedId: Int,
    challengeId: Int,
    completionHandler: @escaping (FeedList) -> Void) {
      KKNetworkManager.shared
        .request(
          object: FeedList.self,
          router: KKRouter.getFeedBlogPost(
            page: currentPage,
            take: count,
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

  func getFeedDetail(completionHandler: @escaping (FeedDetail) -> Void) {
    let feedDeatil = FeedDetail(
      id: 1,
      userId: 2,
      content: "패키지 상품을 받았을때의 기쁨 후엔 \n늘 골치아픈 쓰레기와 분리수거의 노동시간이 뒤따릅니다.\n그래서 GMM은 자원도 아끼고 시간도 아끼고 번거로움도\n줄여주는 종이패키징으로 포장하기로 하였습니다.\n스티커나 비닐을 일체 사용하지 않아서 포장 매무새가 조금\n부족합니다. 너그러이 양해부탁드립니다. 🎀\n제품은 부족함없이 아낌없이 넘치도록 꽉차게 자연성분으로만\n만들었습니다 💚 ",
      storeAddress: "서울특별시 강남구 신사동 613-15번지",
      locationX: "127.102269186127",
      locationY: "37.3771012046504",
      regDate: "2022-06-30",
      nickname: "zerowaster1",
      image: nil,
      promotions: [],
      challenge: [
        Challenge(
          id: 1,
          challengeId: 1,
          title: "#용기내챌린지"
        ),
        Challenge(
          id: 1,
          challengeId: 1,
          title: "#고고챌린지"
        ),
        Challenge(
          id: 1,
          challengeId: 1,
          title: "#제로웨이스트"
        ),
        Challenge(
          id: 1,
          challengeId: 1,
          title: "#지구지키기프로젝트"
        ),
        Challenge(
          id: 1,
          challengeId: 1,
          title: "#프로모션"
        ),
        Challenge(
          id: 1,
          challengeId: 1,
          title: "#업사이클링"
        )
      ],
      images: ["feed_sample_3", "feed_sample_2", "feed_sample_2"],
      scale: "3:4"
    )
    completionHandler(feedDeatil)
  }
}
