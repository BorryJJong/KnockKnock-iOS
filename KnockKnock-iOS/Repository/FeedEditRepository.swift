//
//  FeedEditRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/18.
//

import Foundation

protocol FeedEditRepositoryProtocol {
  func requestEditFeed(completionHandler: @escaping () -> Void)
}

final class FeedEditRepository: FeedEditRepositoryProtocol {
  func requestEditFeed(completionHandler: @escaping () -> Void) {
    
  }
  
}
