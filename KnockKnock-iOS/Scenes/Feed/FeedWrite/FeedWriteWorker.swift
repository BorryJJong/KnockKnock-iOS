//
//  FeedWriteWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/18.
//

import Foundation

protocol FeedWriteWorkerProtocol: AnyObject {
  func uploadFeed(
    postData: FeedWrite,
    completionHandler: @escaping (ApiResponse<Int>?) -> Void
  )
  func checkEssentialField(
    imageCount: Int,
    tag: [ChallengeTitle],
    promotion: [Promotion],
    content: String
  ) -> Bool
  func selectChallenge(
    selectedChallengeId: Int,
    challenges: [ChallengeTitle]
  ) -> [ChallengeTitle]?
  func requestTagList(completionHandler: @escaping (ApiResponse<[ChallengeTitle]>?) -> Void
  )
}

final class FeedWriteWorker: FeedWriteWorkerProtocol {

  // MARK: - Properties

  private let feedWriteRepository: FeedWriteRepositoryProtocol

  // MARK: - Initialize

  init(feedWriteRepository: FeedWriteRepositoryProtocol) {
    self.feedWriteRepository = feedWriteRepository
  }

  func uploadFeed(
    postData: FeedWrite,
    completionHandler: @escaping (ApiResponse<Int>?) -> Void
  ) {
    self.feedWriteRepository.requestFeedPost(
      postData: postData,
      completionHandler: { feedId in

        if feedId?.data != nil {
          self.postWriteNotificationEvent()
        }
        completionHandler(feedId)
      }
    )
  }

  /// 챌린지 참여하기 -> 해당 챌린지 선택 상태 리스트 리턴
  func requestTagList(
    completionHandler: @escaping (ApiResponse<[ChallengeTitle]>?) -> Void
  ) {
    self.feedWriteRepository.requestChallengeTitles(
      completionHandler: { response in
        completionHandler(response)
      }
    )
  }

  func selectChallenge(
    selectedChallengeId: Int,
    challenges: [ChallengeTitle]
  ) -> [ChallengeTitle]? {

    var challenges = challenges
    challenges.remove(at: 0) // '전체' 삭제

    guard let id = challenges.firstIndex(
      where: { $0.id == selectedChallengeId }
    ) else { return nil }

    challenges[id].isSelected = true

    return challenges
  }

  /// 필수 입력 필드 입력 유무 검사
  func checkEssentialField(
    imageCount: Int,
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

    let isImageSelected = imageCount != 0

    let isContentFilled = !content.isEmpty

    let result = isPromotionSelected && isTagSelected && isImageSelected && isContentFilled

    return result
  }
}

extension FeedWriteWorker {

  private func postWriteNotificationEvent() {
    NotificationCenter.default.post(
      name: .feedMainRefreshAfterWrite,
      object: nil
    )
    
    NotificationCenter.default.post(
      name: .homePopularPostRefresh,
      object: nil
    )
  }
}
