//
//  AddComment.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/03/12.
//

import Foundation

struct AddCommentDTO: Encodable {
  let postId: Int
  let content: String
  let commentId: Int?
}
