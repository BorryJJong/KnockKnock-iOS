//
//  BottomSheetWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/23.
//

import Foundation

protocol BottomSheetWorkerProtocol {
  func sharePost(feedData: FeedShare?, completionHandler: @escaping (Bool, KakaoErrorType?) -> Void)
}

final class BottomSheetWorker: BottomSheetWorkerProtocol {

  private let kakaoShareManager: KakaoShareManagerProtocol

  init(kakaoShareManager: KakaoShareManagerProtocol) {
    self.kakaoShareManager = kakaoShareManager
  }

  func sharePost(
    feedData: FeedShare?,
    completionHandler: @escaping (Bool, KakaoErrorType?) -> Void
  ) {

    let result = self.kakaoShareManager.sharePost(feedData: feedData)
    completionHandler(result.0, result.1)

  }
}
