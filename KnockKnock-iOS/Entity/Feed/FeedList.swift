//
//  FeedList.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/10.
//

import Foundation

struct FeedList: Decodable {
  var feeds: [Post]
  let isNext: Bool
  let total: Int

  struct Post: Decodable {
    let id: Int
    let userName: String
    let userImage: String?
    let regDateToString: String
    var content: String?
    let imageScale: String = "1:1"
    var blogLikeCount: String
    var isLike: Bool
    let blogCommentCount: String
    let blogImages: [Image]
    let isWriter: Bool

    mutating func setLikeCount() {
      let title = blogLikeCount.filter({ $0.isNumber })

      let numberFormatter = NumberFormatter().then {
        $0.numberStyle = .decimal
      }

      guard let titleToInt = Int(title) else { return }

      let number = isLike ? (titleToInt + 1) : (titleToInt - 1)
      let newTitle = numberFormatter.string(from: NSNumber(value: number)) ?? ""

      blogLikeCount = " \(newTitle)"
    }

    func toShare() -> FeedShare? {
      
      return FeedShare(
        id: id,
        nickname: userName,
        content: content ?? "",
        imageUrl: blogImages[0].fileUrl,
        likeCount: blogLikeCount,
        commentCount: blogCommentCount
      )
    }
  }

  struct Image: Decodable {
    let id: Int
    let fileUrl: String
  }

  mutating func toggleIsLike(feedId: Int) {
    let indexArray = feeds.enumerated().filter {
      $0.1.id == feedId
    }.map { $0.0 }

    indexArray.forEach {
      feeds[$0].isLike.toggle()
      feeds[$0].setLikeCount()
    }
  }

}
