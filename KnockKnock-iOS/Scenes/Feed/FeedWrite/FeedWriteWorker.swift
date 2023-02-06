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
    completionHandler: @escaping () -> Void
  )
  func checkEssentialField(
    imageCount: Int,
    tag: [ChallengeTitle],
    promotion: [Promotion],
    content: String
  ) -> Bool
  
  func requestTagList(
    selectedChallengeId: Int,
    completionHandler: @escaping ([ChallengeTitle]) -> Void
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
    completionHandler: @escaping () -> Void
  ) {
    self.feedWriteRepository.requestFeedPost(
      postData: postData,
      completionHandler: {
        completionHandler()
      }
    )
  }

  /// 챌린지 참여하기 -> 해당 챌린지 선택 상태 리스트 리턴
  func requestTagList(
    selectedChallengeId: Int,
    completionHandler: @escaping ([ChallengeTitle]) -> Void
  ) {
    self.feedWriteRepository.requestChallengeTitles(
      completionHandler: { response in
        var challenges = response
        challenges.remove(at: 0) // '전체' 삭제

        guard let id = challenges.firstIndex(
          where: { $0.id == selectedChallengeId }
        ) else { return }
        
        challenges[id].isSelected = true
        
        completionHandler(challenges)
      }
    )
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
