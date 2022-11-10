//
//  PropertySelectPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/04.
//

import UIKit

protocol PropertySelectPresenterProtocol {
  var view: PropertySelectViewProtocol? { get set }

  func presentPromotionList(promotionList: [SelectablePromotion])
  func presentTagList(tagList: [ChallengeTitle])
}

final class PropertySelectPresenter: PropertySelectPresenterProtocol {
  weak var view: PropertySelectViewProtocol?

  func presentPromotionList(promotionList: [SelectablePromotion]) {
    self.view?.fetchPromotionList(promotionList: promotionList)
  }

  func presentTagList(tagList: [ChallengeTitle]) {
    self.view?.fetchTagList(tagList: tagList)
  }
}
