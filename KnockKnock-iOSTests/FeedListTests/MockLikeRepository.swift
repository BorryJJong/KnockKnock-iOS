//
//  MockLikeRepository.swift
//  KnockKnock-iOSTests
//
//  Created by Daye on 2023/02/08.
//

@testable import KnockKnock_iOS

final class MockLikeRepository: LikeRepositoryProtocol {

  func requestLike(
    id: Int,
    completionHandler: @escaping (Bool) -> Void
  ) {
    completionHandler(true)
  }

  func requestLikeCancel(
    id: Int,
    completionHandler: @escaping (Bool) -> Void
  ) {
    completionHandler(true)
  }

  func requestLikeList(
    feedId: Int,
    completionHandler: @escaping ([KnockKnock_iOS.Like.Info]) -> Void
  ) {

  }
}
