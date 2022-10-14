//
//  CommentRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/20.
//

import Foundation

import Alamofire

protocol CommentRepositoryProtocol {
  func requestComments(feedId: Int, completionHandler: @escaping ([CommentData]) -> Void)
}

final class CommentRepository: CommentRepositoryProtocol {
  func requestComments(feedId: Int, completionHandler: @escaping ([CommentData]) -> Void) {
    KKNetworkManager.shared
      .request(
        object: CommentResponse.self,
        router: KKRouter.getComment(id: feedId),
        success: { response in
          if let data = response.data {
            completionHandler(data)
          }
        },
        failure: { error in
          print(error)
        }
      )
  }

  func requestAddComment(feedId: Int, userId: Int, content: String, commentId: Int) {
    KKNetworkManager.shared
      .upload(router: KKRouter.postAddComment(postId: feedId, userId: userId, content: content, commentId: commentId), multipartFormData: <#T##MultipartFormData#>)
  }
}
