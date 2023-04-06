//
//  PropertySelectPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/04.
//

import Foundation

protocol PropertySelectPresenterProtocol {
  var view: PropertySelectViewProtocol? { get set }

  func presentPromotionList(promotionList: [Promotion])
  func presentTagList(tagList: [ChallengeTitle])

  func presentAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

final class PropertySelectPresenter: PropertySelectPresenterProtocol {
  weak var view: PropertySelectViewProtocol?

  func presentPromotionList(promotionList: [Promotion]) {
    self.view?.fetchPromotionList(promotionList: promotionList)
  }

  func presentTagList(tagList: [ChallengeTitle]) {
    self.view?.fetchTagList(tagList: tagList)
  }

  func presentAlert(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: (() -> Void)? = nil
  ) {
    self.view?.showAlertView(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}
