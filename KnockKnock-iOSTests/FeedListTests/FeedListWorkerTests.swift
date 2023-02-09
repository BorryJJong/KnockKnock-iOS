//
//  FeedListWorkerTests.swift
//  KnockKnock-iOSTests
//
//  Created by Daye on 2023/02/08.
//

import XCTest

@testable import KnockKnock_iOS

final class FeedListWorkerTests: XCTestCase {

  var feedRepository: FeedRepositoryProtocol!
  var likeRepository: LikeRepositoryProtocol!
  var dataManager: UserDataManagerProtocol!
  var feedListWorker: FeedListWorker!

  override func setUpWithError() throws {

    try super.setUpWithError()

    self.feedRepository = MockFeedListRepository()
    self.likeRepository = MockLikeRepository()
    self.dataManager = MockUserDataManager()
    self.feedListWorker = FeedListWorker(
      feedRepository: self.feedRepository,
      likeRepository: self.likeRepository,
      userDataManager: self.dataManager
    )

  }

  override func tearDownWithError() throws {

    self.feedRepository = nil
    self.likeRepository = nil
    self.dataManager = nil
    self.feedListWorker = nil

    try super.setUpWithError()

  }

  func test_좋아요_상태_테스트() {

    // given
    var mockFeedList: [FeedList.Post] = []

    self.feedRepository.requestFeedList(
      currentPage: -1,
      pageSize: -1,
      feedId: -1,
      challengeId: -1
    ) { feedList in
        mockFeedList = feedList.feeds
      }

    // when
    let isLike = self.feedListWorker.checkCurrentLikeState(
      feedList: mockFeedList,
      feedId: 4
    )

    // then
    XCTAssertEqual(isLike, true)
  }

  func test_좋아요_상태_변경_테스트() {

    //given
    var mockFeedList: FeedList?

    let feeds: [FeedList.Post] =  [
      FeedList.Post(
        id: 4,
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
        isLike: false,
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

    let expectedFeedList: FeedList = .init(
      feeds: feeds,
      isNext: false,
      total: 100
    )

    self.feedRepository.requestFeedList(
      currentPage: -1,
      pageSize: -1,
      feedId: -1,
      challengeId: -1
    ) { feedList in
        mockFeedList = feedList
      }

    // when
    let sections = self.feedListWorker.convertLikeFeed(
      feeds: mockFeedList!,
      id: 4
    )

    // then
    XCTAssertEqual(sections.feeds.map { $0.isLike }, expectedFeedList.feeds.map { $0.isLike })
  }
}
