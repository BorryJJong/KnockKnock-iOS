//
//  FeedWritePresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/18.
//

import Foundation

protocol FeedWritePresenterProtocol: AnyObject {
  var view: FeedWriteViewProtocol? { get set }

  func presentSelectedPromotions(promotionList: [Promotion])
  func presentSelectedTags(tagList: [ChallengeTitle])
  func presentShopAddress(address: String)
}

final class FeedWritePresenter: FeedWritePresenterProtocol {
  weak var view: FeedWriteViewProtocol?

  func presentShopAddress(address: String) {
    self.view?.fetchProperty(
      propertyType: .address,
      content: address
    )
  }

  func presentSelectedPromotions(promotionList: [Promotion]) {
    let selection = promotionList.filter { $0.isSelected == true }

    var content = selection.map {
      $0.promotionInfo.type
    }.joined(separator: ", ")

    if selection.isEmpty {
      content = "프로모션"
    }
    self.view?.fetchProperty(
      propertyType: .promotion,
      content: content
    )
  }

  func presentSelectedTags(tagList: [ChallengeTitle]) {
    let selection = tagList.filter { $0.isSelected == true }

    var content = selection.map {
      $0.title
    }.joined(separator: ", ")

    if selection.isEmpty {
      content = "#태그"
    }
    self.view?.fetchProperty(
      propertyType: .tag,
      content: content
    )
  }
}
