//
//  PropertySelectPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/04.
//

import UIKit

protocol PropertySelectPresenterProtocol {
  var view: PropertySelectViewProtocol? { get set }

  func presentPromotionList(promotionList: [Promotion])
}

final class PropertySelectPresenter: PropertySelectPresenterProtocol {
  weak var view: PropertySelectViewProtocol?

  func presentPromotionList(promotionList: [Promotion]){
    self.view?.fetchPromotionList(promotionList: promotionList)
  }
}
