//
//  FeedWritePresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/18.
//

import Foundation

protocol FeedWritePresenterProtocol: AnyObject {
  var view: FeedWriteViewProtocol? { get set }

  func fetchProperty(propertyType: PropertyType, content: String)

  func presentSelectedPromotions(promotionList: [Promotion])
  func presentSelectedTags(tagList: [ChallengeTitle])
}

final class FeedWritePresenter: FeedWritePresenterProtocol {
  weak var view: FeedWriteViewProtocol?

  func presentSelectedPromotions(promotionList: [Promotion]) {
    self.view?.fetchSelectedPromotions(promotionList: promotionList)
  }
  
  func presentSelectedTags(tagList: [ChallengeTitle]) {
    self.view?.fetchSelectedTags(tagList: tagList)
  }

  func fetchProperty(
    propertyType: PropertyType,
    content: String
  ) {
    self.view?.fetchProperty(
      propertyType: propertyType,
      content: content
    )
  }
}
