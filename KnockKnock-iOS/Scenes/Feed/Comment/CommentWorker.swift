//
//  CommentWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import Foundation

protocol CommentWorkerProtocol {
  func getAllComments(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<[Comment]>?) -> Void
  )
  func requestAddComment(
    comment: AddCommentDTO,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
  func fetchVisibleComments(comments: [Comment]?) -> [Comment]
  func requestDeleteComment(
    feedId: Int,
    commentId: Int,
    comments: [Comment],
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
  func convertDeletedComment(
    comments: [Comment],
    commentId: Int
  ) -> [Comment]
  
  func checkTokenIsValidated() async -> Bool
}

final class CommentWorker: CommentWorkerProtocol {
  
  typealias OnCompletionHandler = (Bool) -> Void
  
  // MARK: - Properties
  
  private let commentRepository: CommentRepositoryProtocol?
  private let userDataManager: UserDataManagerProtocol
  
  // MARK: - Initialize
  
  init(
    commentRepository: CommentRepositoryProtocol,
    userDataManager: UserDataManagerProtocol
  ){
    self.commentRepository = commentRepository
    self.userDataManager = userDataManager
  }
  
  func getAllComments(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<[Comment]>?) -> Void
  ) {

    self.commentRepository?.requestComments(
      feedId: feedId,
      completionHandler: { response in
   
        completionHandler(response)
      }
    )
  }
  
  /// 전체 댓글에서 삭제된 댓글, 숨김(접힘) 상태 댓글을 제외하고 보여질 댓글만 필터링
  func fetchVisibleComments(comments: [Comment]?) -> [Comment] {
    var visibleComments: [Comment] = []
    
    guard let comments = comments else { return [] }
    
    comments.filter({
      !$0.data.isDeleted
    }).forEach { comment in
      
      if comment.isOpen {
        visibleComments.append(comment)
        
        let reply = comment.data.reply.map {
          $0.filter { !$0.isDeleted }
        } ?? []
        
        visibleComments += reply.map {
          Comment(
            data: Comment.Data(
              id: $0.id,
              userId: $0.userId,
              nickname: $0.nickname,
              image: $0.image,
              content: $0.content,
              regDate: $0.regDate,
              isDeleted: $0.isDeleted,
              isWriter: $0.isWriter,
              replyCnt: 0,
              reply: []
            ), isReply: true
          )
        }
      } else {
        if !comment.isReply {
          visibleComments.append(comment)
        }
      }
    }
    return visibleComments
  }
  
  func requestAddComment(
    comment: AddCommentDTO,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  ) {
    self.commentRepository?.requestAddComment(
      comment: comment,
      completionHandler: { response in

        if let isSuccess = response?.data {
          if isSuccess {
            self.postAddNotificationEvent(feedId: comment.postId)
          }
        }

        completionHandler(response)
      }
    )
  }
  
  func requestDeleteComment(
    feedId: Int,
    commentId: Int,
    comments: [Comment],
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  ) {
    
    self.commentRepository?.requestDeleteComment(
      commentId: commentId,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        if response?.data == true {
          if let commentIndex = comments.firstIndex(
            where: { $0.data.id == commentId }
          ) {
            self.postDeleteNotificationEvent(
              feedId: feedId,
              replyCount: comments[commentIndex].data.replyCnt
            )
          }
        }
        completionHandler(response)
      }
    )
  }
  
  func convertDeletedComment(
    comments: [Comment],
    commentId: Int
  ) -> [Comment] {
    var comments = comments

    // 댓글 삭제
    if let index = comments.firstIndex(where: { $0.data.id == commentId }) {
      comments[index].data.isDeleted = true
    }

    // 답글 삭제
    for commentIndex in 0..<comments.count {
      if let replyIndex = comments[commentIndex].data.reply?.firstIndex(where: {
        $0.id == commentId
      }) {
        comments[commentIndex].data.reply?[replyIndex].isDeleted = true
      }
    }
    
    return comments
  }
  
  func checkTokenIsValidated() async -> Bool {
    return await self.userDataManager.checkTokenIsValidated()
  }
  
}

extension CommentWorker {
  private func postAddNotificationEvent(feedId: Int) {
    NotificationCenter.default.post(
      name: .feedListCommentRefreshAfterAdd,
      object: feedId
    )
  }
  
  private func postDeleteNotificationEvent(
    feedId: Int,
    replyCount: Int
  ) {
    
    let object: [String: Any] = [
      "feedId": feedId,
      "replyCount": replyCount
    ]
    
    NotificationCenter.default.post(
      name: .feedListCommentRefreshAfterDelete,
      object: object
    )
  }
}
