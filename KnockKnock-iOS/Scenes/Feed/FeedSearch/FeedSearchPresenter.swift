//
//  FeedSearchPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/14.
//

import UIKit

protocol FeedSearchPresenterProtocol {
  var view: FeedSearchViewProtocol? { get set }
  func presentSearchLog(searchKeyword: [SearchKeyword])
}

final class FeedSearchPresenter: FeedSearchPresenterProtocol {
  var view: FeedSearchViewProtocol?

  func presentSearchLog(searchKeyword: [SearchKeyword]) {
    self.view?.fetchSearchLog(searchKeyword: searchKeyword)
  }
}
