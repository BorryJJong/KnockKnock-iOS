//
//  FeedEditInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/18.
//

import UIKit

protocol FeedEditInteractorProtocol: AnyObject {
  var router: FeedEditRouterProtocol? { get set }
  var worker: FeedEditWorkerProtocol? { get set }
  var presenter: FeedEditPresenterProtocol? { get set }

  func fetchOriginPost(feedId: Int)
  func setCurrentText(text: String)
}

final class FeedEditInteractor: FeedEditInteractorProtocol {

  // MARK: - Properties

  var router: FeedEditRouterProtocol?
  var worker: FeedEditWorkerProtocol?
  var presenter: FeedEditPresenterProtocol?

  private var feedDetail: FeedDetail?

  private var postContent: String = ""

  // MARK: - Business Logic

  func fetchOriginPost(feedId: Int) {

    self.worker?.fetchOriginPost(
      feedId: feedId,
      completionHandler: { [weak self] feedDetail in
        self?.feedDetail = feedDetail
        self?.presenter?.presentOriginPost(feedDetail: feedDetail)
      }
    )
  }

  func setCurrentText(text: String) {
    self.postContent = text
  }

  // MARK: - Routing

}
