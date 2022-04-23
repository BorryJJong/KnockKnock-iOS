//
//  ChellengeRepository.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/04/23.
//

import Foundation

import Alamofire

protocol ChallengeRepositoryProtocol {
  func fetchChellenge() -> [Challenge]
}

final class ChallengeRepository: ChallengeRepositoryProtocol {
  
  /// 해다 영역에서 네트워크 통신하여 데이터를 Fetch 합니다.
  func fetchChellenge() -> [Challenge] {
    return [
      Challenge(title: "Gogo 챌린지", contents: "쓰레기를 줄이쟈쓰레기를 줄이쟈쓰레기를 줄이쟈쓰레기를 줄이쟈"),
      Challenge(title: "제로웨이스트", contents: "쓰레기를 줄이쟈쓰레기를 줄이쟈쓰레기를 줄이쟈쓰레기를 줄이쟈"),
      Challenge(title: "오호호호호호호", contents: "쓰레기를 줄이쟈쓰레기를 줄이쟈쓰레기를 줄이쟈쓰레기를 줄이쟈"),
    ]
  }
}
