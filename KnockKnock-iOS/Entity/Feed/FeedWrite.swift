//
//  FeedWrite.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/05.
//

import UIKit

// MARK: - 피드 등록

/// 피드 등록 entity
struct FeedWrite {
  let content: String
  let storeAddress: String?
  let storeName: String?
  let locationX: String
  let locationY: String
  let scale: String
  let promotions: String
  let challenges: String
  let images: [UIImage]
}

/// 피드 등록 api response
struct FeedWriteDTO: Decodable {
  let code: Int
  let message: String
}
