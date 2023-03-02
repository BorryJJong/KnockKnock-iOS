//
//  FeedSearchPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/14.
//

import Foundation

protocol FeedSearchPresenterProtocol {
  var view: FeedSearchViewProtocol? { get set }
  func presentSearchKeywords(searchKeywords: [SearchTap: [SearchKeyword]])
}

final class FeedSearchPresenter: FeedSearchPresenterProtocol {
  var view: FeedSearchViewProtocol?

  func presentSearchKeywords(searchKeywords: [SearchTap: [SearchKeyword]]) {
    self.view?.fetchSearchKeywords(searchKeywords: searchKeywords)
  }
}
