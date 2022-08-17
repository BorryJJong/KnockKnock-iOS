//
//  LikeRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/02.
//

import Foundation

protocol LikeRepositoryProtocol {
  func getlike(completionHandler: @escaping ([Like]) -> Void)
}

final class LikeRepository: LikeRepositoryProtocol {
  func getlike(completionHandler: @escaping ([Like]) -> Void) {
    let like = [
      Like(userId: 2, nickname: "ksungmin94", image: nil),
      Like(userId: 2, nickname: "jerrychoi", image: nil),
      Like(userId: 2, nickname: "jjong", image: nil),
      Like(userId: 2, nickname: "borry", image: nil),
      Like(userId: 2, nickname: "sangwon", image: nil),
      Like(userId: 2, nickname: "honggyu", image: nil),
      Like(userId: 2, nickname: "daye", image: nil),
      Like(userId: 2, nickname: "username", image: nil)
    ]
    completionHandler(like)
  }
}
