//
//  ChellengeRepository.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/04/23.
//

import Foundation

import Alamofire

protocol ChallengeRepositoryProtocol {
  func fetchChellenge(completionHandler: @escaping ([Challenges]) -> Void)
}

final class ChallengeRepository: ChallengeRepositoryProtocol {
  
  /// 해다 영역에서 네트워크 통신하여 데이터를 Fetch 합니다.
  func fetchChellenge(completionHandler: @escaping ([Challenges]) -> Void) {
    APIService().getChallenges(callback: { response in
      completionHandler(response)
    })
  }
}
