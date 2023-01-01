//
//  FeedDetailInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import UIKit

protocol FeedDetailInteractorProtocol {
  var worker: FeedDetailWorkerProtocol? { get set }
  var presenter: FeedDetailPresenterProtocol? { get set }
  var router: FeedDetailRouterProtocol? { get set }

  func getFeedDeatil(feedId: Int)

  func fetchAllComments(feedId: Int)
  func fetchVisibleComments()
  func toggleVisibleStatus(commentId: Int)

  func requestAddComment(comment: AddCommentRequest)
  func requestDeleteComment(commentId: Int)
  func fetchLikeList(feedId: Int)

  func navigateToLikeDetail(source: FeedDetailViewProtocol)
}

final class FeedDetailInteractor: FeedDetailInteractorProtocol {
  var worker: FeedDetailWorkerProtocol?
  var presenter: FeedDetailPresenterProtocol?
  var router: FeedDetailRouterProtocol?

  private var likeList: [LikeInfo] = []

  /// 서버에서 받아온 전체 댓글 array
  var comments: [Comment] = []

  /// view에서 보여지는 댓글 array(open 상태 댓글만)
  var visibleComments: [Comment] = []

  // MARK: - Business logic

  func getFeedDeatil(feedId: Int) {
    self.worker?.getFeedDetail(
      feedId: feedId,
      completionHandler: { [weak self] feedDetail in
        self?.presenter?.presentFeedDetail(feedDetail: feedDetail)
      }
    )
  }

  func fetchLikeList(feedId: Int) {
    self.worker?.fetchLikeList(
      feedId: feedId,
      completionHandler: { [weak self] likeList in
        self?.likeList = likeList
        self?.presenter?.presentLike(like: likeList)
      }
    )
  }

  /// 댓글 목록 조회 api로부터 받은 전체 댓글 fetch
  func fetchAllComments(feedId: Int) {
    self.worker?.getAllComments(
      feedId: feedId,
      completionHandler: { [weak self] comments in
        self?.comments = comments
        self?.fetchVisibleComments()
      }
    )
  }

  /// 답글 펼침/숨김 상태 toggle
  func toggleVisibleStatus(commentId: Int) {
    guard let index = self.comments.firstIndex(where: {
      $0.data.id == commentId
    }) else { return }
    
    self.comments[index].isOpen.toggle()
    self.fetchVisibleComments()
  }

  /// 전체 댓글에서 삭제된 댓글, 숨김(접힘) 상태 댓글을 제외하고 보여질 댓글만 필터링
  func fetchVisibleComments() {
    self.visibleComments = []

    self.comments.filter({
      !$0.data.isDeleted
    }).forEach { comment in

      if comment.isOpen {
        self.visibleComments.append(comment)

        let reply = comment.data.reply.map {
          $0.filter { !$0.isDeleted }
        } ?? []

        self.visibleComments += reply.map {
          Comment(
            data: CommentResponse.Data(
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
    self.presenter?.presentVisibleComments(allComments: self.visibleComments)
  }

  /// 답글을 포함한 모든 댓글의 수 (헤더에 표기)
  func fetchAllCommentsCount(comments: [Comment]) {
    var count = comments.count

    comments.forEach {
      count += $0.data.reply?.count ?? 0
    }
    self.presenter?.presentAllCommentsCount(allCommentsCount: count)
  }

  /// 댓글 등록
  func requestAddComment(
    comment: AddCommentRequest
  ) {
    self.worker?.requestAddComment(
      comment: comment,
      completionHandler: { response in
        if response == "success" {
          self.fetchAllComments(feedId: comment.postId)
        }
      }
    )
  }

  /// 댓글 삭제
  func requestDeleteComment(commentId: Int) {
    self.worker?.requestDeleteComment(
      commentId: commentId,
      completionHandler: {

        if let index = self.comments.firstIndex(where: { $0.data.id == commentId }) {
          self.comments[index].data.isDeleted = true
        }

        for commentIndex in 0..<self.comments.count {
          if let replyIndex = self.comments[commentIndex].data.reply?.firstIndex(where: {
            $0.id == commentId
          }) {
            self.comments[commentIndex].data.reply?[replyIndex].isDeleted = true
          }
        }

        self.fetchVisibleComments()
      }
    )
  }
  // MARK: - Routing

  func navigateToLikeDetail(source: FeedDetailViewProtocol) {
    self.router?.navigateToLikeDetail(source: source, like: self.likeList)
  }
}
