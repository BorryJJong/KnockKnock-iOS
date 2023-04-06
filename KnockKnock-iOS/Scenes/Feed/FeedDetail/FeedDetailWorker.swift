//
//  FeedDetailWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import Foundation

final class FeedDetailWorker: FeedDetailWorkerProtocol {
  typealias OnCompletionHandler = (ApiResponse<Bool>?) -> Void

  // MARK: - Properties

  private let feedDetailRepository: FeedDetailRepositoryProtocol
  private let commentRepository: CommentRepositoryProtocol
  private let likeRepository: LikeRepositoryProtocol
  private let userDataManager: UserDataManagerProtocol

  // MARK: - Initialize

  init(
    feedDetailRepository: FeedDetailRepositoryProtocol,
    commentRepository: CommentRepositoryProtocol,
    likeRepository: LikeRepositoryProtocol,
    userDataManager: UserDataManagerProtocol
  ) {
    self.feedDetailRepository = feedDetailRepository
    self.commentRepository = commentRepository
    self.likeRepository = likeRepository
    self.userDataManager = userDataManager
  }

  // MARK: - Functions

  /// 피드 상세 조회
  func getFeedDetail(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<FeedDetail>?) -> Void
  ) {
    self.feedDetailRepository.requestFeedDetail(
      feedId: feedId,
      completionHandler: { feed in
        completionHandler(feed)
      }
    )
  }

  func requestDeleteFeed(
    feedId: Int,
    completionHandler: @escaping OnCompletionHandler
  ) {
    self.feedDetailRepository.requestDeleteFeed(
      feedId: feedId,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        if let isSuccess = response?.data {
          if isSuccess {
            self.postResfreshNotificationEvent(feedId: feedId)
          }
        }

        completionHandler(response)
      }
    )
  }

  /// 게시글 숨기기
  /// - Parameters:
  ///  - feedId: 피드 아이디
  func requestHidePost(
    feedId: Int,
    completionHandler: @escaping OnCompletionHandler
  ) {
    self.feedDetailRepository.requestHidePost(
      feedId: feedId,
      completionHandler: { [weak self] response in

        guard let self = self else { return }
        if let isSuccess = response?.data {
          if isSuccess {
            self.postResfreshNotificationEvent(feedId: feedId)
          }
        }
        completionHandler(response)
      }
    )
  }

  /// 피드 신고하기
  ///
  /// - Parameters:
  ///  - feedId: 피드 아이디
  ///  - reportType: 신고 타입
  func requestReportFeed(
    feedId: Int,
    reportType: ReportType,
    completionHandler: @escaping OnCompletionHandler
  ) {
    self.feedDetailRepository.requestReportPost(
      feedId: feedId,
      reportType: reportType,
      completionHandler: { response in

        if let isSuccess = response?.data {
          if isSuccess {
            self.postResfreshNotificationEvent(feedId: feedId)
          }
        }

        completionHandler(response)

      }
    )
  }

  /// 유저 차단 api call
  func requestBlockUser(userId: Int) async -> ApiResponse<Bool>? {
    let response = await self.feedDetailRepository.requestBlockUser(userId: userId)

    if let isSuccess = response?.data {
      if isSuccess {
        self.postUserBlockedEvent()
      }
    }

    return response
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

  func getAllComments(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<[Comment]>?) -> Void
  ) {

    self.commentRepository.requestComments(
      feedId: feedId,
      completionHandler: { response in

        completionHandler(response)
      }
    )
  }

  func checkTokenIsValidated() async -> Bool {
    return await self.userDataManager.checkTokenIsValidated()
  }

  func requestLike(
    isLike: Bool,
    feedId: Int,
    completionHandler: @escaping OnCompletionHandler
  ) {

    if !isLike {
      self.likeRepository.requestLike(
        id: feedId,
        completionHandler: { [weak self] response in

          guard let self = self else { return }

          if let isSuccess = response?.data {
            if isSuccess {
              self.postLikeNotificationEvent(feedId: feedId)
            }
          }

          completionHandler(response)
        }
      )
    } else {
      self.likeRepository.requestLikeCancel(
        id: feedId,
        completionHandler: { [weak self] response in

          guard let self = self else { return }

          if let isSuccess = response?.data {
            if isSuccess {
              self.postLikeNotificationEvent(feedId: feedId)
            }
          }

          completionHandler(response)
        }
      )
    }
  }

  func toggleLike(feedDetail: FeedDetail?) -> FeedDetail? {
    var feedDetail = feedDetail

    feedDetail?.feed.isLike.toggle()

    return feedDetail
  }

  func fetchLikeList(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<[Like.Info]>?) -> Void
  ) {
    self.likeRepository.requestLikeList(
      feedId: feedId,
      completionHandler: { likeList in
        completionHandler(likeList)
      }
    )
  }

  func requestAddComment(
    comment: AddCommentDTO,
    completionHandler: @escaping OnCompletionHandler
  ) {
    self.commentRepository.requestAddComment(
      comment: comment,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        if let isSuccess = response?.data {
          if isSuccess {
            self.postCommentAddNotificationEvent(feedId: comment.postId)
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
    completionHandler: @escaping OnCompletionHandler
  ) {
    self.commentRepository.requestDeleteComment(
      commentId: commentId,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        if response?.data == true {
          if let commentIndex = comments.firstIndex(
            where: { $0.data.id == commentId }
          ) {

            self.postCommentDeleteNotificationEvent(
              feedId: feedId,
              replyCount: comments[commentIndex].data.replyCnt
            )
          } else {
            self.postCommentDeleteNotificationEvent(
              feedId: feedId,
              replyCount: 0
            )
          }
        }
        completionHandler(response)
      }
    )
  }
}

// MAKR: - Inner Actions

extension FeedDetailWorker {
  private func postResfreshNotificationEvent(feedId: Int) {
    NotificationCenter.default.post(
      name: .feedListRefreshAfterDelete,
      object: feedId
    )
    
    NotificationCenter.default.post(
      name: .feedMainRefreshAfterDelete,
      object: feedId
    )

    NotificationCenter.default.post(
      name: .homePopularPostRefresh,
      object: nil
    )
  }

  private func postLikeNotificationEvent(feedId: Int) {
    NotificationCenter.default.post(
      name: .postLikeToggled,
      object: feedId
    )
  }

  private func postUserBlockedEvent() {
    NotificationCenter.default.post(
      name: .feedListRefreshAfterBlocked,
      object: nil
    )

    NotificationCenter.default.post(
      name: .feedMainRefreshAfterBlocked,
      object: nil
    )

    NotificationCenter.default.post(
      name: .homePopularPostRefresh,
      object: nil
    )
  }

  private func postCommentAddNotificationEvent(feedId: Int) {
    NotificationCenter.default.post(
      name: .feedListCommentRefreshAfterAdd,
      object: feedId
    )
  }

  private func postCommentDeleteNotificationEvent(
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
