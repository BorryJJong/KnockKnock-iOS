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
    completionHandler: @escaping (Bool) -> Void
  )
  func fetchVisibleComments(comments: [Comment]?) -> [Comment]
  func requestDeleteComment(
    feedId: Int,
    commentId: Int,
    comments: [Comment],
    completionHandler: @escaping (Bool) -> Void
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
//        let commentData = response?.data?.map { Comment(data: $0) }
//        data += commentData
//        
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
    completionHandler: @escaping OnCompletionHandler
  ) {
    self.commentRepository?.requestAddComment(
      comment: comment,
      completionHandler: { isSuccess in
        if isSuccess {
          self.postAddNotificationEvent(feedId: comment.postId)
        }
        completionHandler(isSuccess)
      }
    )
  }
  
  func requestDeleteComment(
    feedId: Int,
    commentId: Int,
    comments: [Comment],
    completionHandler: @escaping OnCompletionHandler
  ) {
    
    self.commentRepository?.requestDeleteComment(
      commentId: commentId,
      completionHandler: { isSuccess in
        if isSuccess {
          
          guard let commentIndex = comments.firstIndex(
            where: { $0.data.id == commentId }
          ) else { return }
          
          self.postDeleteNotificationEvent(
            feedId: feedId,
            replyCount: comments[commentIndex].data.replyCnt
          )
          
        }
        completionHandler(isSuccess)
      }
    )
  }
  
  func convertDeletedComment(
    comments: [Comment],
    commentId: Int
  ) -> [Comment] {
    var comments = comments
    
    if let index = comments.firstIndex(where: { $0.data.id == commentId }) {
      comments[index].data.isDeleted = true
    }
    
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
