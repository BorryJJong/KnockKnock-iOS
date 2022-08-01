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

  func getFeedDeatil()
  func getAllComments()
  func setVisibleComments(comments: [Comment])
}

final class FeedDetailInteractor: FeedDetailInteractorProtocol {
  var worker: FeedDetailWorkerProtocol?
  var presenter: FeedDetailPresenterProtocol?

  func getFeedDeatil() {
    self.worker?.getFeedDetail { [weak self] feedDetail in
      self?.presenter?.presentFeedDetail(feedDetail: feedDetail)
    }
  }

  func getAllComments() {
    self.worker?.getAllComments(complitionHandler: {[weak self] comments in
      self?.presenter?.presentAllComments(allComments: comments)
    })
  }

  func setVisibleComments(comments: [Comment]) {
    self.presenter?.setVisibleComments(visibleComments: comments)
  }
}
