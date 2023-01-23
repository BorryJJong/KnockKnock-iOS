//
//  BottomSheetWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/23.
//

import Foundation

protocol BottomSheetWorkerProtocol {
  func sharePost(feedData: FeedList.Post?, completionHandler: @escaping (Bool) -> Void)
}

final class BottomSheetWorker: BottomSheetWorkerProtocol {

  private let kakaoShareManager: KakaoShareManagerProtocol

  init(kakaoShareManager: KakaoShareManagerProtocol) {
    self.kakaoShareManager = kakaoShareManager
  }

  func sharePost(
    feedData: FeedList.Post?,
    completionHandler: @escaping (Bool) -> Void
  ) {

    let result = self.kakaoShareManager.sharePost(feedData: feedData)
    completionHandler(result)

  }
}
