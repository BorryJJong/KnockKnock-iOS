//
//  PropertySelectInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/04.
//

import UIKit

protocol PropertySelectInteractorProtocol {
  var worker: PropertySelectWorkerProtocol? { get set }
  var presenter: PropertySelectPresenterProtocol? { get set }

  func fetchPromotionList()
}

final class PropertySelectInteractor: PropertySelectInteractorProtocol {
  var worker: PropertySelectWorkerProtocol?
  var presenter: PropertySelectPresenterProtocol?

  func fetchPromotionList() {
    self.worker?.requestPromotionList(completionHandler: { promotionList in
      self.presenter?.presentPromotionList(promotionList: promotionList)
    })
  }
}
