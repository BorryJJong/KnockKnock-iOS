//
//  FeedEditWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/18.
//

import UIKit

protocol FeedEditWorkerProtocol {
  func fetchOriginPost(feedId: Int, completionHandler: @escaping (FeedDetail) -> Void)
  func requestPromotionList(completionHandler: @escaping ([Promotion]) -> Void)
  func requestTagList(completionHandler: @escaping ([ChallengeTitle]) -> Void)
  func requestFeedEdit(
    id: Int,
    postData: FeedEdit,
    completionHandler: @escaping (Bool) -> Void
  )
  func checkEssentialField(
    tag: [ChallengeTitle],
    promotion: [Promotion],
    content: String
  ) -> Bool
}

final class FeedEditWorker: FeedEditWorkerProtocol {

  private let feedRepository: FeedRepositoryProtocol
  private let feedWriteRepository: FeedWriteRepositoryProtocol
  private let feedEditRepository: FeedEditRepositoryProtocol

  init(
    feedRepository: FeedRepositoryProtocol,
    feedWriteRepository: FeedWriteRepositoryProtocol,
    feedEditRepository: FeedEditRepositoryProtocol
  ) {
    self.feedRepository = feedRepository
    self.feedWriteRepository = feedWriteRepository
    self.feedEditRepository = feedEditRepository
  }

  /// 기존 게시글 데이터 조회
  ///
  /// - Parameters:
  ///  - feedId: 피드 아이디
  func fetchOriginPost(
    feedId: Int,
    completionHandler: @escaping (FeedDetail) -> Void
  ) {
    self.feedRepository.requestFeedDetail(
      feedId: feedId,
      completionHandler: { feed in
        completionHandler(feed)
      }
    )
  }

  /// 프로모션 리스트 조회 api call
  func requestPromotionList(completionHandler: @escaping ([Promotion]) -> Void) {
    self.feedWriteRepository.requestPromotionList(completionHandler: { response in
      completionHandler(response)
    })
  }

  /// 챌린지 리스트 조회 api call
  func requestTagList(completionHandler: @escaping ([ChallengeTitle]) -> Void) {
    self.feedWriteRepository.requestChallengeTitles(completionHandler: { response in
      completionHandler(response)
    })
  }

  /// 피드 수정
  ///
  /// - Parameters:
  ///  - id: 피드 아이디
  ///  - postData: 수정 된 데이터
  func requestFeedEdit(
    id: Int,
    postData: FeedEdit,
    completionHandler: @escaping (Bool) -> Void
  ) {
    self.feedEditRepository.requestEditFeed(
      id: id,
      postData: postData,
      completionHandler: { isSuccess in
        if isSuccess {
          self.postEditNotificationEvent(feedId: id, contents: postData.content)
        }
        completionHandler(isSuccess)
      }
    )
  }

  /// 필수 값 입력 유무 판별
  ///
  /// - Parameters:
  ///  - tag: 챌린지 Array
  ///  - promotion: 프로모션 Array
  ///  - content: 내용
  func checkEssentialField(
    tag: [ChallengeTitle],
    promotion: [Promotion],
    content: String
  ) -> Bool {

    let isPromotionSelected = promotion.filter {
      $0.isSelected == true
    }.count != 0

    let isTagSelected = tag.filter{
      $0.isSelected == true
    }.count != 0

    let isContentFilled = !content.isEmpty

    let result = isPromotionSelected && isTagSelected && isContentFilled

    return result
   }

}

extension FeedEditWorker {

  /// Notification Center post(피드 수정)
  ///
  /// - Parameters:
  ///  - feedId: 수정 피드 아이디
  ///  - contents: 피드 내용(피드 리스트에서만 사용)
  private func postEditNotificationEvent(
    feedId: Int,
    contents: String? = nil
  ) {

    let feedData: [String: Any] = [
      "feedId": feedId,
      "contents": contents
    ]

    NotificationCenter.default.post(
      name: .feedListRefreshAfterEdited,
      object: feedData
    )

    NotificationCenter.default.post(
      name: .feedDetailRefreshAfterEdited,
      object: feedId
    )
  }
}
