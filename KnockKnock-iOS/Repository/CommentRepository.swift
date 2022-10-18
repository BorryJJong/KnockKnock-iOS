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
    KKNetworkManager
      .shared
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

  func requestAddComment(feedId: Int, userId: Int, content: String, commentId: Int?) {
    let parameters = [
      "feedId": feedId,
      "userId": userId,
      "content": content,
      "commentId": commentId
    ] as [String: Any]

    AF.upload(multipartFormData: { multipartFormData in
      for (key, value) in parameters {
        if let temp = value as? String {
          multipartFormData.append(temp.data(using: .utf8)!, withName: key)
        }
        if let temp = value as? Int {
          multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
        }
      }
    }, with: KKRouter.postAddComment)
    .validate()
    .responseData(completionHandler: { response in
      switch response.result {
      case .success(let data):
          print(data)
      case .failure(let err):
        print(err)
      }
    })

//    AF.upload(multipartFormData: multipartFormData, with: KKRouter.postAddComment(comment: parameters))
//      .validate(statusCode: 200..<500)
//      .responseData { response in
//        switch response.result {
//        case .success:
//          print(response)
//        case .failure(let err):
//          print(err.asAFError)
//        }
//      }

//    KKNetworkManager
//      .shared
//      .upload(
//        multipartFormData: { multipartFormData in
//          for (key, value) in parameters {
//            multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//          }
//          print(multipartFormData)
//        }, router: KKRouter.postAddComment(comment: parameters)
//      )
  }
}
