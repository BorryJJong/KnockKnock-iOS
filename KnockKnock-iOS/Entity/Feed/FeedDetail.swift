//
//  FeedDetail.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/05.
//

import Foundation

struct FeedDetail: Decodable {
  
  let feed: Post?
  let promotions: [Promotion]
  let challenges: [Challenge]
  let images: [Image]
  
  struct Post: Decodable {
    let id: Int
    let userId: Int
    let content: String
    let storeAddress: String?
    let storeName: String?
    let locationX: String
    let locationY: String
    let regDate: String
    let userName: String
    let userImage: String?
    let scale: String = "1:1"
    let isLike: Bool
  }
  
  struct Promotion: Decodable {
    let id: Int
    let promotionId: Int
    let title: String
  }
  
  struct Challenge: Decodable {
    let id: Int
    let challengeId: Int
    let title: String
  }
  
  struct Image: Decodable {
    let id: Int
    let fileUrl: String
  }
}
