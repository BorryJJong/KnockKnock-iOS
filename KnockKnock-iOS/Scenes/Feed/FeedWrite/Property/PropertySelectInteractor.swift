//
//  PropertySelectInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/04.
//

import Foundation

protocol PropertySelectInteractorProtocol {
  var worker: PropertySelectWorkerProtocol? { get set }
  var presenter: PropertySelectPresenterProtocol? { get set }

  func fetchPromotionList()
  func fetchTagList()
}

final class PropertySelectInteractor: PropertySelectInteractorProtocol {
  var worker: PropertySelectWorkerProtocol?
  var presenter: PropertySelectPresenterProtocol?

  func fetchPromotionList() {
    self.worker?.requestPromotionList(completionHandler: { promotions in
      let promotionList = promotions.map {
        Promotion(
          id: $0.id,
          type: $0.type,
          isSelected: false
        )
      }
      self.presenter?.presentPromotionList(promotionList: promotionList)
    })
  }

  func fetchTagList() {
    self.worker?.requestTagList(completionHandler: { tagList in
      self.presenter?.presentTagList(tagList: tagList)
    })
  }
}
