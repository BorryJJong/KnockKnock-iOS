//
//  FeedSearchInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/14.
//

import UIKit

protocol FeedSearchInteractorProtocol {
  var presenter: FeedSearchPresenterProtocol? { get set }
  var worker: FeedSearchWorkerProtocol? { get set }

  func getSearchLog()
}

final class FeedSearchInteractor: FeedSearchInteractorProtocol {
  var presenter: FeedSearchPresenterProtocol?
  var worker: FeedSearchWorkerProtocol?

  func getSearchLog() {
    self.worker?.getSearchLog { [weak self] log in
      self?.presenter?.presentSearchLog(searchKeyword: log)
    }
  }
}
