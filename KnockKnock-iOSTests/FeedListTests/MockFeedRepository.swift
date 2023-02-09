//
//  MockFeedRepository.swift
//  KnockKnock-iOSTests
//
//  Created by Daye on 2023/02/08.
//

@testable import KnockKnock_iOS

final class MockFeedListRepository: FeedRepositoryProtocol {

  func requestHidePost(
    feedId: Int,
    completionHandler: @escaping (Bool) -> Void
  ) {

  }

  func requestFeedMain(
    currentPage: Int,
    totalCount: Int,
    challengeId: Int,
    completionHandler: @escaping (KnockKnock_iOS.FeedMain) -> Void
  ) {

  }

  func requestDeleteFeed(
    feedId: Int,
    completionHandler: @escaping (Bool) -> Void
  ) {

  }

  func requestChallengeTitles(
    completionHandler: @escaping ([KnockKnock_iOS.ChallengeTitle]) -> Void
  ) {

  }

  func requestFeedDetail(
    feedId: Int,
    completionHandler: @escaping (KnockKnock_iOS.FeedDetail) -> Void
  ) {

  }

  func requestFeedList(
    currentPage: Int,
    pageSize: Int,
    feedId: Int,
    challengeId: Int,
    completionHandler: @escaping (KnockKnock_iOS.FeedList) -> Void
  ) {

    let feeds: [FeedList.Post] =  [
      FeedList.Post(
        id: 4,
        userName: "userName",
        userImage: "",
        regDateToString: "",
        content: "", blogLikeCount: "",
        isLike: true,
        blogCommentCount: "",
        blogImages: [],
        isWriter: false
      ),
      FeedList.Post(
        id: 2,
        userName: "userName",
        userImage: "",
        regDateToString: "",
        content: "", blogLikeCount: "",
        isLike: false,
        blogCommentCount: "",
        blogImages: [],
        isWriter: false
      ),
      FeedList.Post(
        id: 4,
        userName: "userName",
        userImage: "",
        regDateToString: "",
        content: "", blogLikeCount: "",
        isLike: true,
        blogCommentCount: "",
        blogImages: [],
        isWriter: false
      ),
      FeedList.Post(
        id: 3,
        userName: "userName",
        userImage: "",
        regDateToString: "",
        content: "", blogLikeCount: "",
        isLike: true,
        blogCommentCount: "",
        blogImages: [],
        isWriter: false
      )
    ]

    let mockFeedList: FeedList = .init(
      feeds: feeds,
      isNext: false,
      total: 100
    )

    completionHandler(mockFeedList)
  }
}
