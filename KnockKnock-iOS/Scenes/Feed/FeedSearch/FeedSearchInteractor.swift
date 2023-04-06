//
//  FeedSearchInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/14.
//

import Foundation

protocol FeedSearchInteractorProtocol {
  var presenter: FeedSearchPresenterProtocol? { get set }
  var worker: FeedSearchWorkerProtocol? { get set }

  func getSearchKeywords()
  func distributeSearchKeywords(searchKeywords: [SearchKeyword]) -> [SearchTap: [SearchKeyword]]
}

final class FeedSearchInteractor: FeedSearchInteractorProtocol {
  var presenter: FeedSearchPresenterProtocol?
  var worker: FeedSearchWorkerProtocol?

  func getSearchKeywords() {
    self.worker?.getSearchKeywords { [weak self] keywords in
      if let searchKeywords = self?.distributeSearchKeywords(searchKeywords: keywords) {
        self?.presenter?.presentSearchKeywords(searchKeywords: searchKeywords)
      }

    }
  }

  func distributeSearchKeywords(searchKeywords: [SearchKeyword]) -> [SearchTap: [SearchKeyword]] {
    var keywords: [SearchTap: [SearchKeyword]] = [
      SearchTap.popular: [],
      SearchTap.tag: [],
      SearchTap.account: [],
      SearchTap.place: []
    ]

    var tagKeywords: [SearchKeyword] = []
    var accountKeywords: [SearchKeyword] = []
    var placeKeywords: [SearchKeyword] = []

    for i in 0..<searchKeywords.count {
      let tap = SearchTap(rawValue: searchKeywords[i].category)
      switch tap {
      case .account:
        accountKeywords.append(searchKeywords[i])
      case .tag:
        tagKeywords.append(searchKeywords[i])
      case .place:
        placeKeywords.append(searchKeywords[i])
      default:
        print("error")
      }
    }

    keywords.updateValue(searchKeywords, forKey: SearchTap.popular)
    keywords.updateValue(tagKeywords, forKey: SearchTap.tag)
    keywords.updateValue(accountKeywords, forKey: SearchTap.account)
    keywords.updateValue(placeKeywords, forKey: SearchTap.place)

    return keywords
  }
}
