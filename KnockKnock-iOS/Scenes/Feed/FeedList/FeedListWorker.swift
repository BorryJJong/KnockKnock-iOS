//
//  FeedListWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/26.
//

import UIKit

protocol FeedListWorkerProtocol {
  func fetchFeedList(
    currentPage: Int,
    count: Int,
    feedId: Int,
    challengeId: Int,
    completionHandler: @escaping (FeedList) -> Void
  )
  func requestDeleteFeed(
    feedId: Int,
    completionHandler: @escaping (Bool) -> Void
  )
  func requestLike(
    isLike: Bool,
    feedId: Int,
    completionHandler: @escaping (Bool) -> Void
  )
  func requestHidePost(
    feedId: Int,
    completionHandler: @escaping (Bool) -> Void
  )
  func requestReportFeed(
    feedId: Int,
    reportType: ReportType,
    completionHandler: @escaping (Bool) -> Void
  )
  func removePostInFeedList(
    feeds: FeedList,
    id: Int
  ) -> FeedList
  
  func updatePostInFeedList(
    feeds: FeedList,
    feedId: Int,
    contents: String
  ) -> FeedList
  
  func checkTokenExisted() -> Bool
  
  func checkCurrentLikeState(
    feedList: [FeedList.Post],
    feedId: Int
  ) -> Bool
  
  func changedSections(
    feeds: [FeedList.Post],
    id: Int
  ) -> [Int]
  
  func convertLikeFeed(
    feeds: FeedList,
    id: Int
  ) -> FeedList

  func convertComment(
    feeds: FeedList,
    id: Int,
    replyCount: Int?,
    isAdded: Bool
  ) -> FeedList
}

final class FeedListWorker: FeedListWorkerProtocol {
  typealias OnCompletionHandler = (Bool) -> Void
  
  private let feedRepository: FeedRepositoryProtocol
  private let likeRepository: LikeRepositoryProtocol
  private let userDataManager: UserDataManagerProtocol
  
  init(
    feedRepository: FeedRepositoryProtocol,
    likeRepository: LikeRepositoryProtocol,
    userDataManager: UserDataManagerProtocol
  ) {
    self.feedRepository = feedRepository
    self.likeRepository = likeRepository
    self.userDataManager = userDataManager
  }

  /// 피드 삭제 api call
  func requestDeleteFeed(
    feedId: Int,
    completionHandler: @escaping OnCompletionHandler
  ) {
    self.feedRepository.requestDeleteFeed(
      feedId: feedId,
      completionHandler: { isSuccess in
        if isSuccess {
          self.postResfreshNotificationEvent(feedId: feedId)
        }
        completionHandler(isSuccess)
      }
    )
  }

  /// 게시글 숨기기
  func requestHidePost(
    feedId: Int,
    completionHandler: @escaping (Bool) -> Void
  ) {
    self.feedRepository.requestHidePost(
      feedId: feedId,
      completionHandler: { isSuccess in
        if isSuccess {
          self.postResfreshNotificationEvent(feedId: feedId)
        }
        completionHandler(isSuccess)
      }
    )
  }

  /// 이미 조회 된 피드 리스트 내에서 게시글 삭제하기
  ///
  /// - Parameters:
  ///  - feeds: 조회 된 피드 데이터
  ///  - id: 피드 아이디
  func removePostInFeedList(
    feeds: FeedList,
    id: Int
  ) -> FeedList {
    var feeds = feeds
    
    let sections = self.changedSections(
      feeds: feeds.feeds,
      id: id
    )
    
    for _ in 0..<sections.count {
      if let feedIndex = feeds.feeds.firstIndex(where: {
        $0.id == id
      }) {
        feeds.feeds.remove(at: feedIndex)
      }
    }
    
    return feeds
  }

  /// 조회 된 피드 데이터 수정
  ///
  /// - Parameters:
  ///  - feeds: 조회 된 피드 데이터
  ///  - feedId: 피드 아이디
  ///  - contents: 수정된 내용
  func updatePostInFeedList(
    feeds: FeedList,
    feedId: Int,
    contents: String
  ) -> FeedList {
    var feeds = feeds
    
    let sections = self.changedSections(
      feeds: feeds.feeds,
      id: feedId
    )
    
    for section in sections {
      feeds.feeds[section].content = contents
    }
    
    return feeds
  }

  /// 토큰 존재 여부 판별을 통해 로그인 된 회원 인지 판별
  func checkTokenExisted() -> Bool {
    return self.userDataManager.checkTokenIsExisted()
  }

  /// 피드 리스트 조회 api call
  ///
  /// - Parameters:
  ///  - currentPage: 현재 페이지 넘버
  ///  - count: 조회할 개수
  ///  - feedId: 첫 번째(시작) 피드 아이디
  ///  - challengeId: 챌린지 아이디
  func fetchFeedList(
    currentPage: Int,
    count: Int,
    feedId: Int,
    challengeId: Int,
    completionHandler: @escaping (FeedList) -> Void
  ) {
    self.feedRepository.requestFeedList(
      currentPage: currentPage,
      pageSize: count,
      feedId: feedId,
      challengeId: challengeId,
      completionHandler: { result in
        completionHandler(result)
      }
    )
  }

  /// 좋아요 api call
  ///
  /// - Parameters:
  ///  - isLike: 좋아요 상태
  ///  - feedId: 피드 아이디
  func requestLike(
    isLike: Bool,
    feedId: Int,
    completionHandler: @escaping OnCompletionHandler
  ) {
    if !isLike {
      self.likeRepository.requestLike(
        id: feedId,
        completionHandler: { result in
          completionHandler(result)
        }
      )
    } else {
      self.likeRepository.requestLikeCancel(
        id: feedId,
        completionHandler: { result in
          completionHandler(result)
        }
      )
    }
  }

  /// 이벤트(ex, 수정/삭제/좋아요..)가 발생한 게시글 섹션 넘버 찾기
  ///
  /// - Parameters:
  ///  - feeds: 조회 된 피드 리스트
  ///  - id: 이벤트가 발생한 피드 아이디
  func changedSections(
    feeds: [FeedList.Post],
    id: Int
  ) -> [Int] {
    
    var sections: [Int] = []
    
    for (index, feed) in feeds.enumerated() where feed.id == id {
      sections.append(index)
    }
    
    return sections
  }

  /// 피드 상세에서 좋아요 이벤트 발생 시 좋아요 상태를 반영한 피드 데이터 반환
  ///
  /// - Parameters:
  ///  - feeds: 피드 리스트 데이터
  ///  - id: 피드 아이디
  func convertLikeFeed(
    feeds: FeedList,
    id: Int
  ) -> FeedList {

    var feeds = feeds
    
    self.changedSections(feeds: feeds.feeds, id: id).forEach {
      self.setToggleLike(feed: &feeds.feeds[$0])
      self.setLikeCount(feed: &feeds.feeds[$0])
    }
    
    return feeds
  }

  /// 댓글 등록/삭제 이벤트 발생 시 댓글 개수 업데이트한 피드 데이터 반환
  ///
  /// - Parameters:
  ///  - feeds: 피드 리스트 데이터
  ///  - id: 피드 아이디
  func convertComment(
    feeds: FeedList,
    id: Int,
    replyCount: Int? = nil,
    isAdded: Bool
  ) -> FeedList {
    var feeds = feeds

    self.changedSections(feeds: feeds.feeds, id: id).forEach {
      self.setCommentCount(
        feed: &feeds.feeds[$0],
        replyCount: replyCount ?? 0,
        isAdded: isAdded
      )
    }

    return feeds
  }

  /// 현재 좋아요 상태 체크 (좋아요/비좋아요)
  ///
  /// - Parameters:
  ///  - feedList: 피드 리스트 데이터
  ///  - id: 피드 아이디
  func checkCurrentLikeState(
    feedList: [FeedList.Post],
    feedId: Int
  ) -> Bool {
    var isLike = true
    
    for (index, feed) in feedList.enumerated() where feed.id == feedId {
      isLike = feedList[index].isLike
    }
    return isLike
  }

  /// 피드 신고하기
  ///
  /// - Parameters:
  ///  - feedId: 피드 아이디
  ///  - reportType: 신고 타입
  func requestReportFeed(
    feedId: Int,
    reportType: ReportType,
    completionHandler: @escaping OnCompletionHandler
  ) {
    self.feedRepository.requestReportPost(
      feedId: feedId,
      reportType: reportType,
      completionHandler: { isSuccess in

        completionHandler(isSuccess)

      }
    )
  }
}

// MARK: - Inner Action
extension FeedListWorker {

  /// 좋아요 toggle
  private func setToggleLike(feed: inout FeedList.Post) {
    feed.isLike.toggle()
  }

  /// 좋아요 개수
  private func setLikeCount(feed: inout FeedList.Post) {
    let title = feed.blogLikeCount.filter { $0.isNumber }
    
    let numberFormatter = NumberFormatter().then {
      $0.numberStyle = .decimal
    }
    
    guard let titleToInt = Int(title) else { return }
    
    let number = feed.isLike ? (titleToInt + 1) : (titleToInt - 1)
    let newTitle = numberFormatter.string(from: NSNumber(value: number)) ?? ""
    
    feed.blogLikeCount = " \(newTitle)"
  }

  /// 댓글 개수
  ///
  /// - Parameters:
  ///  - feed: 피드 리스트 데이터
  ///  - isAdded: 등록 이벤트(true), 삭제 이벤트(false)
  private func setCommentCount(
    feed: inout FeedList.Post,
    replyCount: Int,
    isAdded: Bool
  ) {
    let title = feed.blogCommentCount.filter { $0.isNumber }

    let numberFormatter = NumberFormatter().then {
      $0.numberStyle = .decimal
    }

    guard let titleToInt = Int(title) else { return }

    let number = isAdded ? (titleToInt + 1) : (titleToInt - (replyCount + 1))
    let newTitle = numberFormatter.string(from: NSNumber(value: number)) ?? ""

    feed.blogCommentCount = " \(newTitle)"
  }

  /// Notification
  private func postResfreshNotificationEvent(feedId: Int) {
    NotificationCenter.default.post(
      name: .feedMainRefreshAfterDelete,
      object: feedId
    )
  }
}
