//
//  FeedInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import Foundation

protocol FeedInteracotrProtocol {
  var presenter: FeedPresenterProtocol? { get set }
  var worker: FeedWorkerProtocol? { get set }

  func fetchFeed()
}

final class FeedInteractor: FeedInteracotrProtocol {

  // MARK: - Properties
  
  var presenter: FeedPresenterProtocol?
  var worker: FeedWorkerProtocol?

  func fetchFeed() {
    self.worker?.fetchFeed { [weak self] feed in
      self?.presenter?.presentFetchFeed(feed: feed)
    }
  }
}
