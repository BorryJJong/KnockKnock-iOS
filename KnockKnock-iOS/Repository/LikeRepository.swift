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

class LikeRepository: LikeRepositoryProtocol {
  func getlike(completionHandler: @escaping ([Like]) -> Void) {
    let like = [
      Like(userId: 2, nickname: "", image: nil),
      Like(userId: 2, nickname: "", image: nil),
      Like(userId: 2, nickname: "", image: nil),
      Like(userId: 2, nickname: "", image: nil),
      Like(userId: 2, nickname: "", image: nil),
      Like(userId: 2, nickname: "", image: nil),
      Like(userId: 2, nickname: "", image: nil),
      Like(userId: 2, nickname: "", image: nil)
    ]
    completionHandler(like)
  }
}
