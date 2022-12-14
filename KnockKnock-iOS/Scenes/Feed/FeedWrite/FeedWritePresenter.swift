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
  func presentShopAddress(address: AddressResult.Documents)
  func presentAlertView(isDone: Bool)
}

final class FeedWritePresenter: FeedWritePresenterProtocol {
  weak var view: FeedWriteViewProtocol?

  func presentShopAddress(address: AddressResult.Documents) {
    self.view?.fetchAddress(address: address)
  }

  func presentSelectedPromotions(promotionList: [Promotion]) {
    let selection = promotionList.filter { $0.isSelected == true }

    var content = selection.map {
      $0.promotionInfo.type
    }.joined(separator: ", ")

    if selection.isEmpty {
      content = "프로모션"
    }
    self.view?.fetchPromotion(promotion: content)
  }

  func presentSelectedTags(tagList: [ChallengeTitle]) {
    let selection = tagList.filter { $0.isSelected == true }

    var content = selection.map {
      $0.title
    }.joined(separator: ", ")

    if selection.isEmpty {
      content = "#태그"
    }
    self.view?.fetchTag(tag: content)
  }

  func presentAlertView(isDone: Bool) {
    self.view?.showAlertView(isDone: isDone)
  }
}
