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
  func removePostInFeedList(
    feeds: FeedList,
    id: Int
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
  
  func requestDeleteFeed(
    feedId: Int,
    completionHandler: @escaping OnCompletionHandler
  ) {
    self.feedRepository.requestDeleteFeed(
      feedId: feedId,
      completionHandler: { isSuccess in
        self.postResfreshNotificationEvent(feedId: feedId)
        completionHandler(isSuccess)
      }
    )
  }

  func removePostInFeedList(
    feeds: FeedList,
    id: Int
  ) -> FeedList {
    var feeds = feeds

    let sections = self.changedSections(feeds: feeds.feeds, id: id)

    for _ in 0..<sections.count {
      if let feedIndex = feeds.feeds.firstIndex(where: {
        $0.id == id
      }) {
        feeds.feeds.remove(at: feedIndex)
      }
    }

    return feeds
  }
  
  func checkTokenExisted() -> Bool {
    return self.userDataManager.checkTokenIsExisted()
  }
  
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
}

// MARK: - Inner Action
extension FeedListWorker {
  
  private func setToggleLike(feed: inout FeedList.Post) {
    feed.isLike.toggle()
  }
  
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

  private func postResfreshNotificationEvent(feedId: Int) {
    NotificationCenter.default.post(
      name: .feedMainRefreshAfterDelete,
      object: feedId
    )
  }
}
