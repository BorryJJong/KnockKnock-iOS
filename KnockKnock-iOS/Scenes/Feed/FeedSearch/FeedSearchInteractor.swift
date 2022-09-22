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
  func distributeSearchLog(searchLog: [SearchKeyword], category: SearchTap) -> [SearchKeyword]
}

final class FeedSearchInteractor: FeedSearchInteractorProtocol {
  var presenter: FeedSearchPresenterProtocol?
  var worker: FeedSearchWorkerProtocol?

  func getSearchLog() {
    self.worker?.getSearchLog { [weak self] log in
      self?.presenter?.presentSearchLog(searchKeyword: log)
    }
  }

  func distributeSearchLog(searchLog: [SearchKeyword], category: SearchTap) -> [SearchKeyword] {
    var tagKeyword: [SearchKeyword] = []
    var accountKeyword: [SearchKeyword] = []
    var placeKeyword: [SearchKeyword] = []

    for i in 0..<searchLog.count {
      let tap = SearchTap(rawValue: searchLog[i].category)
      switch tap {
      case .account:
        accountKeyword.append(searchLog[i])
      case .tag:
        tagKeyword.append(searchLog[i])
      case .place:
        placeKeyword.append(searchLog[i])
      default:
        return []
      }
    }

    switch category {
    case .popular:
      return searchLog
    case .account:
      return accountKeyword
    case .tag:
      return tagKeyword
    case .place:
      return placeKeyword
    }
  }
}
